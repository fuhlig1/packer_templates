#!/bin/sh

  # Update the box
  yum -y update
  yum -y install linux-headers-$(uname -r) redhat-lsb-core

  if [ "$build_type" = "desktop" ]; then
    yum -y install @xfce
  fi

  # Install the needed software collections when on SLC6 
  # Install newer python and dev tools (compiler + ...)
  distribution=$(lsb_release -is)
  version=$(lsb_release -rs | cut -f1 -d.)

  if [ "$distribution$version" = "ScientificCERNSLC6" ]; then
    wget http://linuxsoft.cern.ch/cern/scl/slc6-scl.repo
    cp slc6-scl.repo /etc/yum.repos.d
    yum -y install python27 devtoolset-3
  fi
