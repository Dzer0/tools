#!/bin/bash
yum install ntp -y
ntpdate server 0.CentOS.pool.ntp.org
date
