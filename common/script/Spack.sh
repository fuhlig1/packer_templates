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

distribution=$(lsb_release -is)
version=$(lsb_release -rs | cut -f1 -d.)

if [ "$distribution$version" = "ScientificCERNSLC6" ]; then
  source scl_source enable devtoolset-3
  source scl_source enable python27
  source scl_source enable git19
fi

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

mkdir -p /opt/spack/source
cd /opt/spack/source

git clone https://github.com/spack/spack
cd spack
git checkout develop
export PATH=$PATH:$PWD/bin
cd ..
git clone https://github.com/fuhlig1/FairSoft-Spack 
cd FairSoft-Spack 
git checkout $fairsoft_tag
cd ..
spack repo add $PWD/FairSoft-Spack

spack config get config > ~/.spack/config.yaml
sed -e "s#\$spack/opt/spack#/opt/spack#g" -i'' ~/.spack/config.yaml
sed -e '/  - $tempdir/ d' -i'' ~/.spack/config.yaml

export FORCE_UNSAFE_CONFIGURE=1
spack install fairsoft

if [ -n "$http_proxy" ]; then
  sed '/^http-proxy-host/d' -i'' $HOME/.subversion/servers
  sed '/^http-proxy-port/d' -i'' $HOME/.subversion/servers
fi
