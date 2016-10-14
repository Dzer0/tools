#!/bin/bash
IMAGE_NAME=$1
#. ${0%/*}/env.sh
. $(cd "$(dirname "$0")";pwd)/env.sh
init
docker pull $REGISTRY_DOMAIN/$IMAGE_NAME && docker tag $REGISTRY_DOMAIN/$IMAGE_NAME $IMAGE_NAME && docker rmi $REGISTRY_DOMAIN/$IMAGE_NAME
