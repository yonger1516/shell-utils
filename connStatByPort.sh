#!/bin/bash

source ./shellUtils.sh

usage(){
    echo "usage:./connStatByPort -p port -[interval number]"

}

PORT=""
INTERVAL=3

until [ $# -eq 0 ]
do 
    case $1 in 
	-[pP])
	     PORT=$2 ;;
	-interval)
	     INTERVAL=$2 ;;
	*)
	     usage;exit -1
    esac

    
shift 2
done

echo "port:"$PORT "interval:"$INTERVAL


while :
do 
    echo "=============================================="
     date "+%Y-%m-%d %H:%M:%S" ;getConnsByPort $PORT
    sleep $INTERVAL
done


