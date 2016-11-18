#!/bin/bash
get_ppid (){
	ps -ef  |grep $1|grep -v 'grep'|awk -v Pid=$1 '{if ($2==Pid){print $3}}'
}
pids=`ps -aux|sed 1d|sort -k4 -rn|head -n 10|awk '{print $2}'`
for pid in ${pids[@]}
do
#set -x
#echo pid=$pid
ppid=${pid}
echo -n "`ps aux |grep $pid|grep -v grep|awk -v a=$pid '{if($2==a){print $4 }}'`	"
	while :
	do
		ppid=`get_ppid ${ppid}`
#		if [ $ppid == "25885" ];then
#			set -x
#			sleep 1
#		fi
		if [ $ppid -lt 1000  ];then
			echo "	it's local_process,pid=$pid"
			break
		fi
		docker inspect  -f '{{.State.Pid}}    {{.Name}}' `docker ps |awk '{print $1}'|sed 1d`|grep  "$ppid" && break
	done
set +x
done
