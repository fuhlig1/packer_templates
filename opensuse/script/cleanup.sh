#!/bin/sh

# Clean up
zypper --non-interactive clean -a
rm -f /etc/zypp/locks

# Remove temporary files
rm -rf /tmp/*

# Zero out free space
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Remove network rules file which will be created otherwise in the 
# wrong way disabling ssh login completely
if [ -f /etc/udev/rules.d/70-persistent-net.rules ]; then
  rm /etc/udev/rules.d/70-persistent-net.rules
fi
