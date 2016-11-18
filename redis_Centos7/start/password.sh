#!/bin/sh
for i in `ls -F|grep /|sed 's#/##g'`
do
    echo "正在修改配置文件......."
    sed -i "s/# requirepass Dzer0_HeRen_IT/requirepass Dzer0_HeRen_IT/g" ./$i/redis.conf
    echo "配置文件修改完毕......开始重启$i节点"
    kill -9 `netstat -apn|grep LISTEN|grep -v LISTENING|grep $i|awk '{print $7}'|sed 's#/.*##'|uniq`
    sleep 5
    cd $i/
    ./redis-server redis.conf
    sleep 3
    echo  "重启完成进行下一个节点"
    cd -
done
echo "所有集群节点设置密码完成，密码为：Dzer0_HeRen_IT"
echo "验证命令：redis-cli -c -a Dzer0_HeRen_IT -h HOST_IP -p PORT"
