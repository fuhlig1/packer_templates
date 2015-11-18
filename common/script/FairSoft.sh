#!/bin/bash

env
echo "tag: $fairsoft_tag"

if [ -n "$http_proxy" ]; then
  echo "Adding proxy to subversion config"
  host=$(echo $http_proxy | cut -f2 -d:)
  host=$(echo $host | sed -e"s#\/##g")
  port=$(echo $http_proxy | cut -f3 -d:)
  port=$(echo $port | sed -e"s#\/##g")
  svn ls https://subversion.gsi.de/cbmsoft/cbmroot
  echo "http-proxy-host = $host" >> $HOME/.subversion/servers
  echo "http-proxy-port = $port" >> $HOME/.subversion/servers
fi

cat  $HOME/.subversion/servers

if [ -d /opt/compiler/gcc ]; then
  export PATH=/opt/compiler/gcc/bin:$PATH
  bit=$(uname -m)
  if [ "$bit" = "x86_64" ]; then
    export LD_LIBRARY_PATH=/opt/compiler/gcc/lib64:/opt/compiler/gcc/lib:$LD_LIBRARY_PATH
  else
    export LD_LIBRARY_PATH=/opt/compiler/gcc/lib32:/opt/compiler/gcc/lib:$LD_LIBRARY_PATH
  fi
fi

set -xv

mkdir -p /opt/fairsoft/source
cd /opt/fairsoft/source

git clone https://github.com/FairRootGroup/FairSoft $fairsoft_tag

cd /opt/fairsoft/source/$fairsoft_tag

#check if it is tag or not
result=$(git tag -l | grep "^$fairsoft_tag$")
if [ $? -eq 0 ]; then # it is a tag
  git checkout -b tag_$fairsoft_tag $fairsoft_tag
else
  git checkout $fairsoft_tag
fi

set +xv

sed -e "s|build_root6=no|build_root6=no|g" -i'' automatic.conf
sed -e "s|\$PWD/installation|/opt/fairsoft/$fairsoft_tag|g" -i'' automatic.conf
sed -e "s|build_python=no|build_python=no|g" -i'' automatic.conf
sed -e "s|compiler=gcc|compiler=|g" -i'' automatic.conf
sed -e "s|compiler=|compiler=gcc|g" -i'' automatic.conf

FC=gfortran ./configure.sh automatic.conf 2>&1 | tee Installation.log
cd && rm -rf /opt/fairsoft/source

if [ -n "$http_proxy" ]; then
  sed '/^http-proxy-host/d' -i'' $HOME/.subversion/servers
  sed '/^http-proxy-port/d' -i'' $HOME/.subversion/servers
fi
