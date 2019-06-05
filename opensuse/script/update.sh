#!/bin/sh

# Update the box
zypper --non-interactive update

if [ "$build_type" = "desktop" ]; then
  zypper --non-interactive install -t pattern xfce
fi

if [ ! -f /usr/bin/shutdown ]; then
  cd /usr/bin
  ln -s /sbin/shutdown
fi
