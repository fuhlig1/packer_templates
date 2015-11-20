#!/bin/bash


set -xv

version=$(lsb_release -rs)

if [ $version -le 21 ]; then
  yum -y autoremove  
  yum -y clean all
  yum -y history new
else   
  dnf -y autoremove  
  dnf -y clean all
  dnf -y history new
fi  
  
truncate -c -s 0 /var/log/yum.log

# Remove temporary files
rm -rf /tmp/*

# Zero out free space
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
