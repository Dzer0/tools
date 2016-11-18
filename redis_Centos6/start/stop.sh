#!/bin/sh
for dir in `ls -F|grep /|sed 's#/##g'`
#for dir in {9000..9005}
do
    kill -9 `netstat -apn|grep LISTEN|grep -v LISTENING|grep $dir|awk '{print $7}'|sed 's#/.*##'|uniq`
    echo "$dir redis节点已经关闭"
    sleep 3
    rm -rf $dir
    echo "$dir 文件夹已经删除"
done
ps -aux |grep redis
