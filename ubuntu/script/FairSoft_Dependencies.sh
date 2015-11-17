#!/bin/bash

DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

DEBIAN_FRONTEND=noninteractive apt-get -y install cmake cmake-data g++ gcc gfortran build-essential make patch sed \
                   libx11-dev libxft-dev libxext-dev libxpm-dev libxmu-dev libglu1-mesa-dev libgl1-mesa-dev \
                   ncurses-dev libcurl4-openssl-dev curl bzip2 gzip unzip tar subversion git xutils-dev flex \
                   bison lsb-release python-dev libc6-dev-i386 libxml2-dev wget libssl-dev \
                   automake autoconf libtool

DEBIAN_FRONTEND=noninteractive apt-get -y clean
DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
