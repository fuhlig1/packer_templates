#!/bin/bash

mkdir -p /opt/fairsoft/source
cd /opt/fairsoft/source

git clone https://github.com/FairRootGroup/FairSoft jul15p2

cd /opt/fairsoft/source/jul15p2
git checkout -b tag_jul15p2 jul15p2

sed -e "s|build_root6=no|build_root6=no|g" -i'' automatic.conf
sed -e "s|\$PWD/installation|/opt/fairsoft/jul15p2|g" -i'' automatic.conf
sed -e "s|build_python=no|build_python=no|g" -i'' automatic.conf
sed -e "s|compiler=gcc|compiler=|g" -i'' automatic.conf
sed -e "s|compiler=|compiler=gcc|g" -i'' automatic.conf

FC=gfortran ./configure.sh automatic.conf 2>&1 | tee Installation.log
cd && rm -rf /opt/fairsoft/source
