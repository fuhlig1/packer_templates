#!/bin/sh

set -xv
# Update the box
zypper --non-interactive update

if [ "$build_type" = "desktop" ]; then
  zypper install --non-interactive -t pattern xfce
fi
set +xv