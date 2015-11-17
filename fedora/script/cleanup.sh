#!/bin/bash

yum -y autoremove  
yum clean all
yum history new
truncate -c -s 0 /var/log/yum.log

# Remove temporary files
rm -rf /tmp/*

# Zero out free space
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
