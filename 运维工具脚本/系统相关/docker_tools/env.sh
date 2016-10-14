#!/bin/bash
set -e
REGISTRY_DOMAIN=仓库域名
REGISTRY_USER=账户
REGISTRY_PASSWD=密码
create_ca (){
	mkdir -p /etc/docker/certs.d/${REGISTRY_DOMAIN} 
        cat >/etc/docker/certs.d/${REGISTRY_DOMAIN}/ca.crt <<EOF
-----BEGIN CERTIFICATE-----
ca.crt内容
-----END CERTIFICATE-----
EOF
}
login_it (){
        docker login -u ${REGISTRY_USER} -p ${REGISTRY_PASSWD}  -e op@herenit.com ${REGISTRY_DOMAIN}
}
init (){
	if [ ! -d "/etc/docker/certs.d/${REGISTRY_DOMAIN}" ] || [ ! -f "/etc/docker/certs.d/${REGISTRY_DOMAIN}/ca.crt" ];then
        	create_ca && login_it;fi
}
