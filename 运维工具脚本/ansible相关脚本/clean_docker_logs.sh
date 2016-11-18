#!/bin/bash
for i in $(ls /var/lib/docker/containers |awk '{print $1}')
do
   du -sh /var/lib/docker/containers/$i/$i-json.log
   echo ''> /var/lib/docker/containers/$i/$i-json.log
   echo /var/lib/docker/containers/$i/$i-json.log
   cat /var/lib/docker/containers/$i/$i-json.log
done

