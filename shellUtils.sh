#!/bin/bash

log_error(){ 
    echo "Error:" $@>&2 
}
log_warn(){ 
    echo "Warn:" $@>&2 
}

printUsage(){ 
    echo "Usage:" $@
    exit -1 
}


######################
#get the connectionns of connecting to the specified port
#
########################

getConnsByPort(){
    port=""
    
    if [ $# -le 0 ]
    then 
	echo "please specify a port";exit -1
    fi 

    echo "# of connections:"
    #netstat -an4|tail -n +3|awk -v col=$desCol -F' ' '{print $col}' |awk -v p=$port -F':' '{if($2==p)count=count+1}END{print count}'
    ss -nt sport = :$1|tail -n +2|wc -l

    echo "connection state details:"
    ss -nt sport = :$1|tail -n +2|awk '{print $1}'|uniq -c|sort -r


}



###################################

connStat(){
    if [ `whoami` == "root" ]
    then 
	echo "port connections"
	ss -nt|tail -n +2|awk '{print $4}'|awk -F':' '{arr[$2]=arr[$2]+1}END{for(i in arr){print i,arr[i]|"sort -r -n -k2";}}'
    else
	echo "please exec this command by root"
    fi
}


######################
#
#
###############################
#
promptYesNo(){
    if [ $# -lt 0 ] 
    then 
	log_error "Insufficient arguments"
	return 1
    fi

    YESNO=""

    while : 
    do 
	printf "$1 yes/no?"
	read YESNO

	case "$YESNO" in 
	 [yY]|[yY][eE][sS])
	    YESNO=y; break;;
	 [nN]|[nN][oO])
	    YESNO=n; break;;
	 *)
	    YESNO="" ;;
	esac
    done

    export YESNO
    return 0
}
