#!/bin/sh

# Update the box
apt-get -y update
apt-get -y upgrade
apt-get -y install ubuntu-desktop
apt-get -y install linux-headers-$(uname -r) 

