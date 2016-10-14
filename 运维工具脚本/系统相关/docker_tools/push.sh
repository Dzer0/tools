#!/bin/bash
base (){
	IMAGE_NAME=$1
	echo $1
	docker tag $IMAGE_NAME $REGISTRY_DOMAIN/$IMAGE_NAME && docker push $REGISTRY_DOMAIN/$IMAGE_NAME && docker rmi $REGISTRY_DOMAIN/$IMAGE_NAME
}

all (){
	docker images|sed 1d|awk '{print $1":"$2}'|while read i;do  base $i;done
}

#. ${0%/*}/env.sh
. $(cd "$(dirname "$0")";pwd)/env.sh
init
case $1 in
	all) all;; 
	* )  base $1;;
esac  

