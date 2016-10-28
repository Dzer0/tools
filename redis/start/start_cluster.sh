#!/bin/sh
for i in {9000..9005};do
    cp -a ../redis3.0.7 $i
    sed -i "s/7000/$i/g" ./$i/redis.conf
    chmod u+x ./$i/redis-server
    cd $i/
    ./redis-server redis.conf
    echo "redis_cluster集群端口$i启动成功"
    sleep 3
    cd -
done
ps -aux |grep redis
