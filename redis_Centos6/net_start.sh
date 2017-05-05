#!/bin/sh
yum install ruby -y 
gem install -l redis-3.0.7.gem
gem install -l rubygems-update-2.6.7.gem
cd start
sh start_cluster.sh
sh create_redis_cluster.sh
