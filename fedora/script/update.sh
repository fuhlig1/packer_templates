#!/bin/sh

# Update the box
yum update
yum install linux-headers-$(uname -r) redhat-lsb

if [ "$build_type" = "desktop" ]; then
  yum install @xfce
fi
  