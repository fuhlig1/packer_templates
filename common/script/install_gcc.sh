#!/bin/bash


distribution=$(lsb_release -is)
version=$(lsb_release -rs | cut -f1 -d.)

if [ "$distribution$version" = "ScientificCERNSLC6" ]; then
  source scl_source enable devtoolset-3
  source scl_source enable python27
fi
  
gcc_major=$(gcc -dumpversion | cut -d. -f1)
gcc_minor=$(gcc -dumpversion | cut -d. -f2)

if [ $gcc_major -gt 4 ]; then
  return
fi

if [ $gcc_major -eq 4 -a $gcc_minor -lt 8 ]; then
  cd /tmp
  wget https://ftp.gnu.org/gnu/gcc/gcc-4.8.4/gcc-4.8.4.tar.bz2
  tar -xjvf gcc-4.8.4.tar.bz2
  cd gcc-4.8.4
  ./contrib/download_prerequisites
  cd ..
  mkdir gcc-4.8.4-build
  cd gcc-4.8.4-build
  $PWD/../gcc-4.8.4/configure --prefix=/opt/compiler/gcc --enable-languages=c,c++,fortran
  make -j$(nproc)
  make install
  cd /tmp
  rm -rf gcc-4.8.4 gcc-4.8.4-build
fi  