#!/bin/bash

set -xv

# which shell is used
ps -p $$
echo $SHELL

echo "tag: $fairroot_tag"

distribution=$(lsb_release -is)
version=$(lsb_release -rs | cut -f1 -d.)

if [ "$distribution$version" = "ScientificCERNSLC6" ]; then
  source scl_source enable devtoolset-3
  source scl_source enable python27
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

if [ -e /opt/fairsoft/${fairsoft_tag}_root${root_version}/bin/cmake ]; then
  export PATH=/opt/fairsoft/${fairsoft_tag}_root${root_version}/bin:$PATH
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

distributor=$(lsb_release -is | cut -f1 -d' ')
release=$(lsb_release -rs)
flavour=$distributor$release
ccomp=$(/opt/fairsoft/${fairsoft_tag}_root${root_version}/bin/fairsoft-config --cc)
cppcomp=$(/opt/fairsoft/${fairsoft_tag}_root${root_version}/bin/fairsoft-config --cxx)

cat > Dart.cfg << EOF
export LINUX_FLAVOUR=$flavour
export FAIRSOFT_VERSION=${fairsoft_tag}_root${root_version}
export SIMPATH=/opt/fairsoft/${fairsoft_tag}_root${root_version}
export CC=$ccomp
export CXX=$cppcomp
export GIT_BRANCH=$fairroot_tag
export BUILDDIR=/tmp/build_fairroot_${fairroot_tag}_fs_${fairsoft_tag}_root${root_version}
#export BUILDDIR=/opt/fairroot/source/$fairroot_tag/build
export SOURCEDIR=/opt/fairroot/source/$fairroot_tag

unset HTTP_PROXY
unset FTP_PROXY
EOF

if [ -d /opt/compiler/gcc ]; then
cat >> Dart.cfg << EOF
export EXTRA_FLAGS="-DUSE_PATH_INFO=TRUE"
EOF
fi

cat Dart.cfg

./Dart.sh Experimental Dart.cfg

cd /tmp/build_fairroot_${fairroot_tag}_fs_${fairsoft_tag}_root${root_version}
#cd /opt/fairroot/source/$fairroot_tag/build
sed -e "s#CMAKE_INSTALL_PREFIX:PATH=/usr/local#CMAKE_INSTALL_PREFIX:PATH=/opt/fairroot/${fairroot_tag}_fs_${fairsoft_tag}_root${root_version}#" -i'' CMakeCache.txt
. ./config.sh
make install -j$(nproc)

set +xv
