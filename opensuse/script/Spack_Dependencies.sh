#!/bin/bash

zypper --non-interactive update

zypper --non-interactive install \
          gcc gcc-c++ gcc-fortran \
          make git subversion \
          curl gzip bzip2 unzip rsync \
          python3 python2 lsb-release
