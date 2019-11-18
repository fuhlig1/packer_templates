#!/bin/bash

DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

# Remove cmake from list to trigger build of FairSofts cmake
DEBIAN_FRONTEND=noninteractive apt-get -y install g++ gcc gfortran build-essential make patch sed \
                   libx11-dev libxft-dev libxext-dev libxpm-dev libxmu-dev libglu1-mesa-dev libgl1-mesa-dev \
                   ncurses-dev libcurl4-openssl-dev curl bzip2 gzip unzip tar subversion git xutils-dev flex \
                   bison lsb-release python-dev libc6-dev-i386 libxml2-dev wget libssl-dev \
                   automake autoconf libtool libbz2-dev libkrb5-dev sqlite3 libsqlite3-dev

#DEBIAN_FRONTEND=noninteractive apt-get -y install cmake cmake-data g++ gcc gfortran build-essential make patch sed \
#                   libx11-dev libxft-dev libxext-dev libxpm-dev libxmu-dev libglu1-mesa-dev libgl1-mesa-dev \
#                   ncurses-dev libcurl4-openssl-dev curl bzip2 gzip unzip tar subversion git xutils-dev flex \
#                   bison lsb-release python-dev libc6-dev-i386 libxml2-dev wget libssl-dev \
#                   automake autoconf libtool libbz2-dev libkrb5-dev sqlite3 libsqlite3-dev

DEBIAN_FRONTEND=noninteractive apt-get -y clean
DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
