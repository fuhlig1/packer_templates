#!/bin/bash

fairsoft_tag=$1

if [ -n $http_proxy ]; then
  host=$(echo $http_proxy | cut -f1 -d:)
  port=$(echo $http_proxy | cut -f2 -d:)
  echo "http-proxy-host = $host" >> /etc/subversion/servers
  echo "http-proxy-port = $port" >> /etc/subversion/servers
fi

mkdir -p /opt/fairsoft/source
cd /opt/fairsoft/source

git clone https://github.com/FairRootGroup/FairSoft $fairsoft_tag

cd /opt/fairsoft/source/jul15p2
git checkout -b tag_$fairsoft_tag $fairsoft_tag

sed -e "s|build_root6=no|build_root6=no|g" -i'' automatic.conf
sed -e "s|\$PWD/installation|/opt/fairsoft/$fairsoft_tag|g" -i'' automatic.conf
sed -e "s|build_python=no|build_python=no|g" -i'' automatic.conf
sed -e "s|compiler=gcc|compiler=|g" -i'' automatic.conf
sed -e "s|compiler=|compiler=gcc|g" -i'' automatic.conf

FC=gfortran ./configure.sh automatic.conf 2>&1 | tee Installation.log
cd && rm -rf /opt/fairsoft/source

if [ -n $http_proxy ]; then
  sed '/^http-proxy-host/d' -i'' /etc/subversion/servers
  sed '/^http-proxy-port/d' -i'' /etc/subversion/servers
fi
