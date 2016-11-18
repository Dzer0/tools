试系统版本CentOS 7.0  最小版本

1、 确认自己的外网 网卡是否是eth0
2、 一键创建集群端口为9000-9005 6个端口
3、 该一键安装不需要联网。


使用方法：
linxu下进入该目录 直接输入 sh start.sh即可



网卡修改
在start目录下
vim  create_redis_cluster.sh
第二行修改网卡即可


端口修改
在start目录下
vim start_cluster.sh
{9000..9005} 即为端口段，根据需求修改即可
也可以写成这种模式9000 9003 9004 9100 9002 8888 去除大括号，直接写成这种：
for i in 9000 8888 2222 6666 8887 7777;do


改脚本只适用于单系统创建集群


目录详解：
redis3.0.7 			基础redis
start      			各种启动脚本
redis-3.0.7.gem 		创建集群需要的redis依赖
ruby-2.2.5.tar.gz 		ruby安装，用于离线安装ruby
rubygems-update-2.6.7.gem	rubygems离线安装包，用于离线安装
start.sh 			汇总的一键启动脚本

start目录下
create_redis_cluster.sh 	创建集群命令
password.sh			一键设置集群密码，注意会导致集群重启，数据可能会丢失
start_cluster.sh 		启动redis集群节点
stop.sh				停止并删除创建的redis