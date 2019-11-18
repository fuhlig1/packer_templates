#!/bin/sh

# Update the box
DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
DEBIAN_FRONTEND=noninteractive apt-get -y install linux-headers-$(uname -r) lsb_release

if [ "$build_type" = "desktop" ]; then
  DEBIAN_FRONTEND=noninteractive apt-get -y install ubuntu-desktop
fi

# create directories needed for singularity container at GSI batchfarm
if [ ! -d /u ]; then
  mkdir -p /u;
fi

if [ ! -d /lustre ]; then
  mkdir -p /lustre;
fi
