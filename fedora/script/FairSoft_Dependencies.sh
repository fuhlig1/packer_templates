#!/bin/bash

version=$(lsb_release -rs)

if [ $version -le 21 ]; then

  yum -y update

  yum -y install cmake gcc gcc-c++ gcc-gfortran make patch sed \
                 libX11-devel libXft-devel libXpm-devel libXext-devel \
                 libXmu-devel mesa-libGLU-devel mesa-libGL-devel ncurses-devel \
                 curl curl-devel bzip2 bzip2-devel gzip unzip tar \
                 expat-devel subversion git flex bison imake redhat-lsb-core python-devel \
                 libxml2-devel wget openssl-devel krb5-devel \
                 automake autoconf libtool which
else
  dnf -y update

  dnf -y install cmake gcc gcc-c++ gcc-gfortran make patch sed \
                 libX11-devel libXft-devel libXpm-devel libXext-devel \
                 libXmu-devel mesa-libGLU-devel mesa-libGL-devel ncurses-devel \
                 curl curl-devel bzip2 bzip2-devel gzip unzip tar \
		 expat-devel subversion git flex bison imake redhat-lsb-core python-devel \
                 libxml2-devel wget openssl-devel krb5-devel \
                 automake autoconf libtool which
fi
