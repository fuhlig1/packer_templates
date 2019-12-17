#!/bin/bash

DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

# The last line of packages is neede to be compatible with the GSI installation on Kronos
# without it is not possible to run the cvmfs installation from the container
DEBIAN_FRONTEND=noninteractive apt-get -y install \
                   cmake cmake-data g++ gcc gfortran \
                   debianutils build-essential make patch sed \
                   libx11-dev libxft-dev libxext-dev libxpm-dev libxmu-dev \
                   libglu1-mesa-dev libgl1-mesa-dev \
                   ncurses-dev curl libcurl4-openssl-dev bzip2 libbz2-dev gzip unzip tar \
		   subversion git xutils-dev flex bison lsb-release python-dev \
		   libc6-dev-i386 libxml2-dev wget libssl-dev libkrb5-dev \
                   automake autoconf libtool sqlite3 libsqlite3-dev \
                   libgif-dev libfcgi0ldbl libgl2ps-dev libatlas-base-dev libfftw3-dev libpq-dev libmariadb-dev-compat



DEBIAN_FRONTEND=noninteractive apt-get -y clean
DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
