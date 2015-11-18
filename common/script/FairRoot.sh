#!/bin/bash

set -xv

echo "tag: $fairroot_tag"

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

mkdir -p /opt/fairroot/source
cd /opt/fairroot/source

git clone https://github.com/FairRootGroup/FairRoot $fairroot_tag

cd /opt/fairroot/source/$fairroot_tag

#check if it is tag or not
result=$(git tag -l | grep "^$fairroot_tag$")
if [ $? -eq 0 ]; then # it is a tag
  git checkout -b tag_$fairroot_tag $fairroot_tag
else
  git checkout $fairroot_tag
fi

distributor=$(lsb_release -is)
release=$(lsb_release -rs)
flavour=$distributor$release

cat > Dart.cfg << EOF
export LINUX_FLAVOUR=$flavour
export FAIRSOFT_VERSION=$fairsoft_tag
export SIMPATH=/opt/fairsoft/$fairsoft_tag
export CC=$($SIMPATH/bin/fairsoft-config --cc)
export CXX=$($SIMPATH/bin/fairsoft-config --cxx)
export GIT_BRANCH=$fairroot_tag
export BUILDDIR=/tmp/build_fairroot_${fairroot_tag}_fs_$fairsoft_tag
export SOURCEDIR=/opt/fairroot/source/$fairroot_tag
EOF

cat Dart.cfg

./Dart.sh Experimental Dart.cfg


if [ -n "$http_proxy" ]; then
  sed '/^http-proxy-host/d' -i'' $HOME/.subversion/servers
  sed '/^http-proxy-port/d' -i'' $HOME/.subversion/servers
fi

set +xv