#!/bin/sh
# 检查etcd是否安装
flanneld --version
if [[ $? -eq 0 ]];
    then 
        echo 'flanneld 已经安装了,请卸载重新安装!!!'
        exit
    else 
        yum -y  install flannel kubernetes
fi

# 以下表示将配置文件输出到指定目录
# 三行的意思分别是 配置etcd_list，配置flannled获取网络配合的key ,配置flanneld的网卡
tee /etc/sysconfig/flanneld <<-'EOF'
FLANNEL_ETCD="ETCD_LIST"
FLANNEL_ETCD_KEY="ETCD_KEY_VALUES"
FLANNEL_OPTIONS="-iface=eno16777736"
EOF

# ETCD_LIST 表示所有ETCD集群列表
# ETCD_KEY_VALUES 表示在ETCD中创建的网络节点key值
# -iface=eth0 表示配置flanneld的网络使用网卡

# 以下表示替换各种关键字
sed -i 's%ETCD_LIST%'$1'%g' /etc/sysconfig/flanneld # 表示替换本机ip
sed -i 's%ETCD_KEY_VALUES%'$2'%g' /etc/sysconfig/flanneld  # 表示替换所有etcd集群列表
# 由于使用sed 在使用/做分隔符是出现报错：sed: -e expression #1, char 19: unknown option to `s' 所以在此将/替换成成%

# 输出现在的网卡路由表
echo "输出现在的网卡路由表"
route -n
# 设置开机启动,并启动
systemctl enable flanneld
systemctl start flanneld
systemctl restart docker
# 输出启动完成后的网卡路由表，方便检查是否成功
echo "下方为输出的路由表，请检查flanneld是否启动成功"
route -n
# 单纯检查flanneld是否安装成功
flanneld --version
if [[ $? -eq 0 ]];
    then 
        echo 'flanneld 安装完成！！'
    else 
        echo 'flanneld 安装失败！！'
fi
