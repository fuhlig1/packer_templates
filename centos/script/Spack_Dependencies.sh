#!/bin/bash


  yum -y update

  yum -y install gcc gcc-c++ gcc-gfortran \
                 make git subversion \
                 curl bzip2 gzip unzip rsync \
                 python
