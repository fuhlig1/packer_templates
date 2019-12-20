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


#git clone -b dev_new_spack https://github.com/FairRootGroup/FairSoft
git clone -b dev_new_spack https://github.com/fuhlig1/FairSoft
cd FairSoft
git submodule update --init

source spack/share/spack/setup-env.sh

mkdir -p ~/.spack
spack config get config > ~/.spack/config.yaml
sed -e "s#\$spack/opt/spack#/opt/spack#g" -i'' ~/.spack/config.yaml
sed -e '/  - $tempdir/ d' -i'' ~/.spack/config.yaml

spack -C ./config bootstrap

spack repo add .

export FORCE_UNSAFE_CONFIGURE=1
spack -C env create jun19 env/jun19/sim_python_threads.yaml
spack env activate jun19
spack -C ./config install

if [ -n "$http_proxy" ]; then
  sed '/^http-proxy-host/d' -i'' $HOME/.subversion/servers
  sed '/^http-proxy-port/d' -i'' $HOME/.subversion/servers
fi
