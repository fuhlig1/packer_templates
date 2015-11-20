#!/bin/bash

version=$(lsb_release -rs)

if [ $version -le 21 ]; then

  yum -y update

  yum -y install cmake gcc gcc-c++ gcc-gfortran make patch sed \
                 libX11-devel libXft-devel libXpm-devel libXext-devel \
                 libXmu-devel mesa-libGLU-devel mesa-libGL-devel ncurses-devel \
                 curl bzip2 libbz2-dev gzip unzip tar expat-devel \
                 subversion git flex bison imake redhat-lsb-core \
                 python-devel libxml2-devel wget openssl-devel curl-devel \
                 automake autoconf libtool
else
  dnf -y update

  dnf -y install cmake gcc gcc-c++ gcc-gfortran make patch sed \
                 libX11-devel libXft-devel libXpm-devel libXext-devel \
                 libXmu-devel mesa-libGLU-devel mesa-libGL-devel ncurses-devel \
                 curl bzip2 libbz2-dev gzip unzip tar expat-devel \
                 subversion git flex bison imake redhat-lsb-core \
                 python-devel libxml2-devel wget openssl-devel curl-devel \
                 automake autoconf libtool
fi
