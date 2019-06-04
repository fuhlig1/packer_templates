#!/bin/bash

version=$(lsb_release -rs)

if [ $version -le 21 ]; then

  yum -y update

  yum -y install \
       gcc gcc-c++ gcc-gfortran \
       make git subversion \
       curl gzip bzip2 unzip rsync \
       python redhat-lsb-core
else
  dnf -y update

  dnf -y install \ 
       gcc gcc-c++ gcc-gfortran \
       make git subversion \
       curl gzip bzip2 unzip rsync \
       python redhat-lsb-core
fi
