#!/bin/bash


  yum -y update

  yum -y install cmake gcc gcc-c++ gcc-gfortran make patch sed \
                 libX11-devel libXft-devel libXpm-devel libXext-devel \
                 libXmu-devel mesa-libGLU-devel mesa-libGL-devel ncurses-devel \
                 curl bzip2 bzip2-devel gzip unzip tar expat-devel \
                 subversion git flex bison imake redhat-lsb-core \
                 python-devel libxml2-devel wget openssl-devel curl-devel \
                 automake autoconf libtool krb5-devel

# libbz2-dev removed, bzip2-devel added, glibc-devel.i686
