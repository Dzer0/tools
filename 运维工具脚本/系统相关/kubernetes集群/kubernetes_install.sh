#!/bin/bash
# 获取本机ip地址
export HOST_IP=$(ifconfig eno16777736 |grep 'inet'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $2}')
# 输出本机ip地址
echo '本机ip地址：' $HOST_IP

# tee /etc/kubernetes/apiserver <<'EOF'
# KUBE_API_ADDRESS="--insecure-bind-address=HOST_IP"
# KUBE_API_PORT="--port=8080"
# KUBELET_PORT="--kubelet-port=10250"
# KUBE_ETCD_SERVERS="--etcd-servers=ETCD_SERVER_LIST"
# KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/16"
# KUBE_ADMISSION_CONTROL="--admission-control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota"
# KUBE_API_ARGS=""
#EOF

# tee /etc/kubernetes/config <<'EOF'
# KUBE_LOGTOSTDERR="--logtostderr=true"
# KUBE_LOG_LEVEL="--v=0"
# KUBE_ALLOW_PRIV="--allow-privileged=false"
#KUBE_MASTER="--master=API_SERVER_LIST"
# EOF

# tee /etc/kubernetes/kubelet <<'EOF'
# KUBELET_ADDRESS="--address=HOST_IP"
# KUBELET_PORT="--port=10250"
# KUBELET_HOSTNAME="--hostname-override=HOST_IP"
# KUBELET_API_SERVER="--api-servers=API_SERVER_LIST"
# KUBELET_POD_INFRA_CONTAINER="--pod-infra-container-image=registry.access.redhat.com/rhel7/pod-infrastructure:latest"
# KUBELET_ARGS=""
#EOF
echo  '————————————————————————————————开始修改配置文件————————————————————————————'
sleep 3
#  apiserver配置修改
echo '————————————————————————————————正在修改apiserver————————————————————————————'
sed -i 's%insecure-bind-address=127.0.0.1%insecure-bind-address='$HOST_IP'%g' /etc/kubernetes/apiserver
sed -i 's%# KUBE_API_PORT="--port=8080"%KUBE_API_PORT="--port=8080"%g' /etc/kubernetes/apiserver
sed -i 's%# KUBELET_PORT="--kubelet-port=10250"%KUBELET_PORT="--kubelet-port=10250"%g' /etc/kubernetes/apiserver
sed -i 's%insecure-bind-address=127.0.0.1%insecure-bind-address='$HOST_IP'%g' /etc/kubernetes/apiserver
sed -i 's%etcd-servers=http://127.0.0.1:2379%etcd-servers='$1'%g' /etc/kubernetes/apiserver
echo '————————————————————————————————修改apiserver完成————————————————————————————'
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

for Dzer0 in kube-apiserver kube-controller-manager kube-scheduler kubelet kube-proxy;
do
systemctl enable $Dzer0
systemctl restart $Dzer0
systemctl status $Dzer0
done
kubectl -s $HOST_IP:8080 get nodes

echo "kubernetes安装完成"
