#!/bin/sh

# Update the box
zypper --non-interactive update

if [ "$build_type" = "desktop" ]; then
  zypper --non-interactive install -t pattern xfce
fi

cd /usr/bin
ln -s /sbin/shutdown
