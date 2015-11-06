#!/bin/sh

# Update the box
apt-get -y install ubuntu-desktop
apt-get -y update
apt-get -y install linux-headers-$(uname -r) 
apt-get -y upgrade

