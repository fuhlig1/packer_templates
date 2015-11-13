#!/bin/sh

# Update the box
apt-get -y update
apt-get -y upgrade
apt-get -y install linux-headers-$(uname -r) 

if [ "$build_type" = "desktop" ]; then
  apt-get -y install xfce4
fi
  