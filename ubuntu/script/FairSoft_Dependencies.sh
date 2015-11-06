#!/bin/bash

apt-get -y update
apt-get -y upgrade

apt-get -y install cmake cmake-data g++ gcc gfortran build-essential make patch sed \
                   libx11-dev libxft-dev libxext-dev libxpm-dev libxmu-dev libglu1-mesa-dev libgl1-mesa-dev \
                   ncurses-dev libcurl4-openssl-dev curl bzip2 gzip unzip tar subversion git xutils-dev flex \
                   bison lsb-release python-dev libc6-dev-i386 libxml2-dev wget libssl-dev

apt-get -y clean && apt-get -y autoremove
