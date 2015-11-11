#!/bin/bash

env
echo "tag: $fairsoft_tag"

if [ -n "$http_proxy" ]; then
  echo "Adding proxy to subversion config"
  prot=$(echo $http_proxy | cut -f1 -d:)
  host=$(echo $http_proxy | cut -f2 -d:)
  port=$(echo $http_proxy | cut -f3 -d:)
  port=$(echo $port | sed -e"s#\/##g")
  echo "http-proxy-host = $prot:$host" >> /etc/subversion/servers
  echo "http-proxy-port = $port" >> /etc/subversion/servers
fi

cat  /etc/subversion/servers

mkdir -p /opt/fairsoft/source
cd /opt/fairsoft/source

git clone https://github.com/FairRootGroup/FairSoft $fairsoft_tag

cd /opt/fairsoft/source/$fairsoft_tag
git checkout -b tag_$fairsoft_tag $fairsoft_tag

sed -e "s|build_root6=no|build_root6=no|g" -i'' automatic.conf
sed -e "s|\$PWD/installation|/opt/fairsoft/$fairsoft_tag|g" -i'' automatic.conf
sed -e "s|build_python=no|build_python=no|g" -i'' automatic.conf
sed -e "s|compiler=gcc|compiler=|g" -i'' automatic.conf
sed -e "s|compiler=|compiler=gcc|g" -i'' automatic.conf

FC=gfortran ./configure.sh automatic.conf 2>&1 | tee Installation.log
cd && rm -rf /opt/fairsoft/source

if [ -n "$http_proxy" ]; then
  sed '/^http-proxy-host/d' -i'' /etc/subversion/servers
  sed '/^http-proxy-port/d' -i'' /etc/subversion/servers
fi
