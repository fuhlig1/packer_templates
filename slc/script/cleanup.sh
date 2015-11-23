#!/bin/bash


set -xv

  yum -y autoremove  
  yum -y clean all
  yum -y history new
  
truncate -c -s 0 /var/log/yum.log

# Remove temporary files
rm -rf /tmp/*

# Zero out free space
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Remove network rules file which will be created otherwise in the 
# wrong way disabling ssh login completely
rm /etc/udev/rules.d/70-persistent-net.rules