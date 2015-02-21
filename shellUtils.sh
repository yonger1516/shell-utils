#!/bin/sh
#set -x


getConnsDetailByPort(){
	port=$1
        netstat -ant4 |tail -n +3 |awk -F' ' '{print $4,$6}'|awk -F':' '{print $2 }'|awk -v p=$port '{if($1==p){print $2}}'|uniq -c|sort -r
}

######################
#get the connectionns of connecting to the specified port
#
########################

getConnsByPort(){
    port=""
    desCol=""
    if [ $# -eq 2 ]
    then 
	port="$2"
	desCol="5"
    else
	port="$1"
	desCol="4"
    fi

    echo "# of connections which connected to the destination port: $port"
    netstat -an4|tail -n +3|awk -v col=$desCol -F' ' '{print $col}' |awk -v p=$port -F':' '{if($2==p)count=count+1}END{print count}'

    echo "connection state details:"
    getConnsDetailByPort $port


}



###################################

connStat(){
    if [ `whoami` == "root" ]
    then 
	echo "port connections"
	netstat -ant4p|tail -n +3|awk -F' ' '{if($6!="LISTEN")print $4}'|awk -F':' '{arr[$2]=arr[$2]+1}END{for(i in arr){print i,arr[i]|"sort -r -n -k2";}}'
    else
	echo "please exec this command by root"
    fi
}
