#!/bin/sh

# Update the box
# make gcc perl are needed to build the kernel modules for the guest additions
DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
DEBIAN_FRONTEND=noninteractive apt-get -y install linux-headers-$(uname -r) lsb-release make gcc perl

if [ "$build_type" = "desktop" ]; then
  DEBIAN_FRONTEND=noninteractive apt-get -y install xfce4
fi

# create directories needed for singularity container at GSI batchfarm
if [ ! -d /u ]; then
  mkdir -p /u;
fi
  
if [ ! -d /lustre ]; then
  mkdir -p /lustre;
fi
      