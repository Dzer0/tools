#!/bin/sh
if_name=eno16777736    #请输入网卡名
cdir=`pwd`
installd (){
    echo '由于没有安装相关依赖，程序正在自动安装 需要时间有点长，请耐心等待！！！'
    sleep 3
    cd ../ && tar -zxf ruby-2.2.5.tar.gz && cd ruby-2.2.5 &&./configure && make && make install
    cd ../
    gem install -l rubygems-update-2.6.7.gem
    gem install -l redis-3.0.7.gem
    cd start
    echo '依赖已经安装完成，3秒后将开始创建集群，请根据操作输入yes'
    sleep 3
    Dzer0
}


Dzer0 (){
    set -x
    IP=`ip a|awk "/${if_name}$/{ print \\$2 }"|sed -n 's/\/.*//p'`
    set +x
    nodes=""
    for dir in `ls -F|grep /|sed 's#/##g'`
    do
	nodes="$nodes $IP:$dir"
    done
    echo '所有的节点ip与端口信息：$nodes'
    set -x
    chmod u+x ../redis3.0.7/redis-trib.rb
    ../redis3.0.7/redis-trib.rb create --replicas 1 $nodes
    set +x
    echo '设置开机启动.......'
    set -x
    chmod u+x /etc/rc.d/rc.local
    echo "/bin/sh $cdir/start_host_redis.sh" >> /etc/rc.d/rc.local
    set +x
}



set -x
ruby -v
if [[ $? -eq 0 ]];
    then
        echo 'ruby已经安装 3秒后开始创建集群，请根据操作输入yes'
        sleep 3
        Dzer0
else
    installd
fi
set +x

