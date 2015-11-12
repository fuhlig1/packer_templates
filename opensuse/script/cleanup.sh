#!/bin/sh

# Clean up
zypper clean -a
rm -f /etc/zypp/locks

# Remove temporary files
rm -rf /tmp/*

# Zero out free space
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
