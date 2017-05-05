#!/bin/sh
wget --version
if [[ $? -eq 0 ]];
    then 
        echo 'wget exists, exit!'
    else 
        yum -y  install wget
fi


echo '下载并替换yum源开始'

mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
echo '下载并替换yum源完成'
yum clean all && yum makecache && yum update -y
 && yum install vim -y && yum install -y net-tools