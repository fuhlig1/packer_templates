#!/bin/bash

zypper --non-interactive update

zypper --non-interactive install cmake gcc gcc-c++ gcc-fortran make patch sed \
                         libX11-devel libXft-devel libXpm-devel libXext-devel \
                         libXmu-devel Mesa-libGL-devel freeglut-devel ncurses-devel \
                         curl bzip2 gzip unzip tar libexpat-devel subversion git \
                         flex bison makedepend lsb-release python-devel \
                         libxml2-devel libopenssl-devel krb5-devel wget \
                         libcurl-devel automake autoconf libtool

