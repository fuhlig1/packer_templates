#!/bin/sh

# Clean up
DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
DEBIAN_FRONTEND=noninteractive apt-get -y clean

# Remove temporary files
rm -rf /tmp/*

# Zero out free space
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
