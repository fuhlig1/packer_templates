#!/bin/sh

set -xv

version=$(lsb_release -rs)

if [ $version -le 21 ]; then

  # Update the box
  yum -y update
  yum -y install linux-headers-$(uname -r) redhat-lsb-core

  if [ "$build_type" = "desktop" ]; then
    yum -y install @xfce
  fi
else
  # Update the box
  dnf -y update
  dnf -y install linux-headers-$(uname -r) redhat-lsb-core

  if [ "$build_type" = "desktop" ]; then
    dnf -y install @xfce
  fi
fi  
  
set +xv