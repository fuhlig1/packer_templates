#!/bin/sh

# Update the box
# make gcc perl are needed to build the kernel modules for the guest additions
DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
DEBIAN_FRONTEND=noninteractive apt-get -y install linux-headers-$(uname -r) lsb-release make gcc perl

if [ "$build_type" = "desktop" ]; then
  DEBIAN_FRONTEND=noninteractive apt-get -y install xfce4
fi
  