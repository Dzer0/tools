#!/bin/sh
# 用法：sh filename nodename node1=http://ip:port,node2=http://ip:port,node3=http://ip:node
# 检查etcd是否安装
etcd --version
if [[ $? -eq 0 ]];
    then 
        echo 'etcd 已经安装了,请检查!!!'
        exit
    else 
        yum -y  install etcd
fi

# 获取本机ip地址
export Dzer0=$(ifconfig eno16777736 |grep 'inet'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $2}')
# 输出本机ip地址
echo $Dzer0

# 以下表示将配置文件输出到指定目录
tee /etc/etcd/etcd.conf <<-'EOF'
ETCD_NAME="name"
ETCD_DATA_DIR="/var/lib/etcd/name"
ETCD_LISTEN_PEER_URLS="http://Dzer0:2380"
ETCD_LISTEN_CLIENT_URLS="http://Dzer0:2379,http://127.0.0.1:2379"
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://Dzer0:2380"
ETCD_ADVERTISE_CLIENT_URLS="http://Dzer0:2379"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster1"
ETCD_INITIAL_CLUSTER="list"
EOF

# Dzer0 表示本机ip
# list 表示所有集群列表 模板 name1=http://ip:port,name2=http://ip:port,name3=http://ip:port
# name 表示集群节点名称

# 以下表示替换各种关键字
sed -i 's%Dzer0%'$Dzer0'%g' /etc/etcd/etcd.conf # 表示替换本机ip
sed -i 's%list%'$2'%g' /etc/etcd/etcd.conf      # 表示替换所有etcd集群列表
sed -i 's/name/'$1'/g' /etc/etcd/etcd.conf	# 表示替换集群名称
# 由于使用sed 在使用/做分隔符是出现报错：sed: -e expression #1, char 19: unknown option to `s' 所以在此将/替换成成%

#sed -i 's/Dzer0/'$Dzer0'/g' ~/etcd.conf # 表示替换本机ip
#sed -i 's/list/'$2'/g' ~/etcd.conf      # 表示替换所有etcd集群列表
#sed -i 's/name/'$1'/g' ~/etcd.conf	# 表示替换集群名称


# 设置开机启动,并启动
systemctl enable etcd
systemctl start etcd

#检查etcd是否安装成功并返回自定义字符串
etcd --version
if [[ $? -eq 0 ]];
    then 
        echo 'ETCD 安装完成！！'
    else 
        echo 'ETCD 安装失败！！'
fi
