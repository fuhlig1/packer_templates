#!/bin/bash

zypper --non-interactive update

zypper --non-interactive install \
          gcc gcc-c++ gcc-fortran \
          make git subversion patch \
          curl gzip bzip2 unzip rsync \
          python python-xml lsb-release
