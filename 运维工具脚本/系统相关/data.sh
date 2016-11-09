#!/bin/bash
block_dev=/dev/xvdc
mount_point=/data
parted $block_dev -s mklabel msdos
parted $block_dev -s mkpart primary  0 100%
mkfs.ext4 ${block_dev}1
mkdir $mount_point
mount ${block_dev}1 $mount_point
echo "${block_dev}1                              /data         ext4    defaults 1 2">>/etc/fstab
