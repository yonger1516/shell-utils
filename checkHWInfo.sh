#!/bin/bash

NUM_CPU=72
NUM_MEM=132047784
NUM_DISK=6
LOGFILE=result.log


check_num(){
    if [ $2 -ne $3 ]
    then
         echo "Checking $1 failed,expected:"$2" actual:"$3>>$LOGFILE
    fi
}

tear_done(){
    ssh root@$1 rm -f /tmp/test*
}

echo "">$LOGFILE

for i in {1..20}
do 
    host=172.16.4.$i
    echo "Checking HW setup info on "$host"..."
    echo "Checking HW setup info on "$host>>$LOGFILE
    cpus=`ssh root@$host cat /proc/cpuinfo|grep  processor|wc -l`
  
    check_num cpu $NUM_CPU $cpus 

    memorys=`ssh root@$host cat /proc/meminfo|grep MemTotal|awk '{print $2}'`
    check_num memory $NUM_MEM $memorys

    arr_disk=`ssh root@$host parted -l|grep -P "Disk /dev/[a-z]+: [0-9]+GB"|awk '{print $2}'|awk -F":" '{print $1}'`
	
    check_num disk $NUM_DISK ${#arr_disk[@]}

   # echo "disk arr:"${arr_disk[*]}
    for disk in ${arr_disk[*]}
    do 
	if [ $disk=="/dev/sda" ]
	then 
	    speed=`ssh root@$host  dd if=/dev/zero of=test.bak bs=4k count=10000 conv=fsync|& awk '/copied/ {print $8 " "  $9}'`
	    echo $disk" write performance :"$speed >>$LOGFILE

	    speed=`ssh root@$host  dd if=/dev/sda of=/dev/null bs=4k count=10000|& awk '/copied/ {print $8 " "  $9}'`
            echo $disk" read performance :"$speed >>$LOGFILE

	    break
	fi
	speed=`ssh root@$host dd if=/dev/zero of=$disk bs=4k count=10000 conv=fsync|& awk  '/copied/ {print $8 " "  $9}'`
	echo $disk" write performance : "$speed >>$LOGFILE
	

	speed=`ssh root@$host dd if=$disk of=/dev/null bs=4k count=10000 |& awk  '/copied/ {print $8 " "  $9}'`
        echo $disk" read performance : "$speed >>$LOGFILE
    done 
    
    echo "============================">>$LOGFILE

    tear_done $host
done

echo "Check done."

