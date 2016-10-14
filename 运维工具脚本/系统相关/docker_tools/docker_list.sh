#!/bin/bash
#. ${0%/*}/env.sh
. $(cd "$(dirname "$0")";pwd)/env.sh
init
USER=$REGISTRY_USER
PASSWORD=$REGISTRY_PASSWD
REGISTRY_DOMAIN=$REGISTRY_DOMAIN
list (){
	NAME=`curl -X GET -k https://$USER':'$PASSWORD'@'$REGISTRY_DOMAIN/v2/_catalog 2>/dev/null | sed  's/{.*:\[\(.*\)\]}*$/\1/' |sed 's/\"//g'|sed 's/,/ /g'`
#	echo -e "name\t\ttag"
	for i in $NAME
	do
	   tags=`curl -X GET -k https://$USER':'$PASSWORD'@'$REGISTRY_DOMAIN/v2/$i/tags/list 2>/dev/null | sed  's/{.*:\[\(.*\)\]}*$/\1/' |sed 's/\"//g'|sed 's/,/ /g'`
#	   echo -n "$i"
	   for n in $tags
	   do
#	     echo -e "\t\t$n "
	     echo "$i:$n"
	   done
	done
}
case $1 in
  list) list;;
  * ) echo "docker_list.sh list username passwd domain" ;;
esac
