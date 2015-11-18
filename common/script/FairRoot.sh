#!/bin/bash

set -xv

echo "tag: $fairroot_tag"

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
ccomp=$(/opt/fairsoft/$fairsoft_tag/bin/fairsoft-config --cc)
cppcomp=$(/opt/fairsoft/$fairsoft_tag/bin/fairsoft-config --cxx)

cat > Dart.cfg << EOF
export LINUX_FLAVOUR=$flavour
export FAIRSOFT_VERSION=$fairsoft_tag
export SIMPATH=/opt/fairsoft/$fairsoft_tag
export CC=$ccomp
export CXX=$cppcomp
export GIT_BRANCH=$fairroot_tag
export BUILDDIR=/tmp/build_fairroot_${fairroot_tag}_fs_$fairsoft_tag
export SOURCEDIR=/opt/fairroot/source/$fairroot_tag
EOF

cat Dart.cfg

./Dart.sh Experimental Dart.cfg

set +xv