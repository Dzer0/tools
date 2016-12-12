#!/bin/sh
cdir=$(cd "$(dirname "$0")"; pwd)/
cd $cdir
for dir in `ls -F|grep /|sed 's#/##g'`
#for dir in {9000..9005}
do
    cd $dir/
    ./redis-server redis.conf
    #kill -9 `netstat -apn|grep LISTEN|grep -v LISTENING|grep $dir|awk '{print $7}'|sed 's#/.*##'|uniq`
    echo "$dir redis节点已经启动"
    sleep 3
    cd -
    #rm -rf $dir
    #echo "$dir 文件夹已经删除"
done
ps -aux |grep redis
