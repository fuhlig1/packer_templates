#!/bin/bash

set -xv

fpm -s dir -t deb -n fairsoft_${fairsoft_tag}_root${root_version} \
-d "cmake" \
-d "cmake-data" \
-d "g++" \
-d "gcc" \
-d "gfortran" \
-d "build-essential" \
-d "make" \
-d "patch" \
-d "sed" \
-d "libx11-dev" \
-d "libxft-dev" \
-d "libxext-dev" \
-d "libxpm-dev" \
-d "libxmu-dev" \
-d "libglu1-mesa-dev" \
-d "libgl1-mesa-dev" \
-d "ncurses-dev" \
-d "libcurl4-openssl-dev" \
-d "curl" \
-d "bzip2" \
-d "gzip" \
-d "unzip" \
-d "tar" \
-d "subversion" \
-d "git" \
-d "xutils-dev" \
-d "flex" \
-d "bison" \
-d "lsb-release" \
-d "python-dev" \
-d "libc6-dev-i386" \
-d "libxml2-dev" \
-d "wget" \
-d "libssl-dev" \
-d "automake" \
-d "autoconf" \
-d "libtool" \
 /opt/fairsoft/${fairsoft_tag}_root${root_version}

set +xv
