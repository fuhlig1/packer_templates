#!/bin/sh

# Update the box
yum -y update
yum -y install linux-headers-$(uname -r) redhat-lsb-core

if [ "$build_type" = "desktop" ]; then
  yum -y install @xfce
fi
  