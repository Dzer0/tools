#!/bin/bash
# 获取本机ip地址
export HOST_IP=$(ifconfig eno16777736 |grep 'inet'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $2}')
# 输出本机ip地址
echo '本机ip地址：' $HOST_IP
echo  '————————————————————————————————开始修改配置文件————————————————————————————'
sleep 3
# config 配置修改
echo '————————————————————————————————正在修改config————————————————————————————'
sed -i 's%master=http://127.0.0.1:8080%master='$2'%g' /etc/kubernetes/config
echo '————————————————————————————————修改config完成————————————————————————————'
sleep 3
# kubelet配置修改
echo '————————————————————————————————正在修改kubelet————————————————————————————'
sed -i 's%address=127.0.0.1%address='$HOST_IP'%g' /etc/kubernetes/kubelet
sed -i 's%hostname-override=127.0.0.1%hostname-override='$HOST_IP'%g' /etc/kubernetes/kubelet
sed -i 's%api-servers=http://127.0.0.1:8080%api-servers='$2'%g' /etc/kubernetes/kubelet
echo '————————————————————————————————修改kubelet完成————————————————————————————'

sleep 3
echo '————————————————————————设置各个服务开机启动并启动服务————————————————————————'

# for Dzer0 in kube-apiserver kube-controller-manager kube-scheduler kubelet kube-proxy;
for Dzer0 in kubelet kube-proxy;
do
systemctl enable $Dzer0
systemctl restart $Dzer0
systemctl status $Dzer0
done
kubectl -s $HOST_IP:8080 get nodes

echo "kubernetes安装完成"
