#!/bin/bash
API_SERVER="100.98.237.28:8080"
PROJECT_NAME="hr-phs"
CONTAINER_LOG_DIR="/mnt"
HOST_LOG_DIR="/pod_log"
KEEP_DAYS=0
CONTAINERS=`docker ps |egrep "hr-phs[vV][0-9]*"|grep -v 'POD'|awk '{print $1}'`
#CONTAINERS=`docker ps |egrep "hr-phs-.*"|grep -v 'POD'|awk '{print $1}'`
find_container_id (){
	sleep 1
}
search_time (){
	local container=${1}
        local keep_time=${2}
	local container_log_dir=${3}
        (( keep_sec=60*60*24*$keep_time ))
	set -x
        array=`docker exec -it ${container} /bin/bash -c "find ${container_log_dir}/*" |dos2unix|sed -rn  "/^.*.[0-2][0-9]{3}-[0-1][0-9]-[0-3][0-9].*$/p"`
	set +x
        LIST_DELETED=()
        LIST_KEEP=()
        for item in ${array[@]}
        do
                item_date=`echo $item|sed -rn 's/^.*.([0-2][0-9]{3}-[0-1][0-9]-[0-3][0-9]).*$/\1/p'`
                tmp=`date -d $item_date  +%s`
                today=`date +%s`
                if (( $today-$keep_sec > $tmp));then
                        LIST_DELETED=( "${LIST_DELETED[*]}" $item)
                else
                        LIST_KEEP=( "${LIST_KEEP[*]}" $item)
                fi
        done
}

copy (){
	local container=${1}
	local container_log_dir=${2}
	local host_log_dir=$3
	local project_name=$4
	echo host_log_dir=$host_log_dir
	local hostname=`docker exec -it ${container} /bin/bash -c 'echo $HOSTNAME'|dos2unix`
	local log_file_path=${host_log_dir}/${project_name}/`date +%Y%m%d`/${hostname}${container_log_dir}
        mkdir -p ${log_file_path}
        docker cp ${container}:${container_log_dir} ${log_file_path}
}

clean (){
	local file_path=($1)
	local container=${2}
	echo file_path=${file_path[*]}
	docker exec -it $container rm -rf ${file_path[@]}
}
dos2unix -V &>/dev/null || yum install dos2unix -y
#find_id
for CONTAINER in $CONTAINERS
do
        echo "container=$CONTAINER"
        search_time $CONTAINER $KEEP_DAYS $CONTAINER_LOG_DIR
        copy ${CONTAINER} ${CONTAINER_LOG_DIR} ${HOST_LOG_DIR} ${PROJECT_NAME}
	clean "${LIST_DELETED[*]}" ${CONTAINER}
	echo LIST_DELETED=${LIST_DELETED[*]}
	echo LIST_KEEP=${LIST_KEEP[*]}
done
echo "END!"
