#!/bin/bash

set -xv

echo "tag: $cbmroot_tag"

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

mkdir -p /opt/cbmroot/source
cd /opt/cbmroot/source

if [ ! -d fieldmaps ]; then
  svn checkout https://subversion.gsi.de/cbmsoft/cbmroot/fieldmaps
fi

if [ ! -d cbmroot_$cbmroot_tag ]; then
  if [ "$cbmroot_tag" = "trunk" ]; then
    svn checkout https://subversion.gsi.de/cbmsoft/cbmroot/trunk cbmroot_$cbmroot_tag
  else
    svn checkout https://subversion.gsi.de/cbmsoft/cbmroot/release/$cbmroot_tag cbmroot_$cbmroot_tag
  fi
fi

cd /opt/cbmroot/source/cbmroot_$cbmroot_tag/input
ln -s ../../fieldmaps/field_v12a.root 
ln -s ../../fieldmaps/field_v12b.root 

cd /opt/cbmroot/source/cbmroot_$cbmroot_tag

distributor=$(lsb_release -is | cut -f1 -d' ')
release=$(lsb_release -rs)
flavour=$distributor$release
ccomp=$(/opt/fairsoft/$fairsoft_tag/bin/fairsoft-config --cc)
cppcomp=$(/opt/fairsoft/$fairsoft_tag/bin/fairsoft-config --cxx)

cat > Dart.cfg << EOF
export LINUX_FLAVOUR=$flavour
export FAIRSOFT_VERSION=$fairsoft_tag
export SIMPATH=/opt/fairsoft/$fairsoft_tag
export FAIRROOT_VERSION=$fairroot_tag
export FAIRROOTPATH=/opt/fairroot/${fairroot_tag}_fs_$fairsoft_tag
export CC=$ccomp
export CXX=$cppcomp
export BUILDDIR=/tmp/build_cbmroot_${cbmroot_tag}_${fairroot_tag}_fs_$fairsoft_tag
export SOURCEDIR=/opt/cbmroot/source/cbmroot_$cbmroot_tag
EOF

if [ -d /opt/compiler/gcc ]; then
cat >> Dart.cfg << EOF
export EXTRA_FLAGS="-DUSE_PATH_INFO=TRUE"
EOF
fi

#mkdir build_${fairroot_tag}_fs_$fairsoft_tag
#cd build_${fairroot_tag}_fs_$fairsoft_tag
#cmake .. -DUSE_PATH_INFO=TRUE
#make -j$(nproc)

cat Dart.cfg

./Dart.sh Nightly Dart.cfg

#cd /tmp/build_fairroot_${fairroot_tag}_fs_$fairsoft_tag
#sed -e "s#CMAKE_INSTALL_PREFIX:PATH=/usr/local#CMAKE_INSTALL_PREFIX:PATH=/opt/fairroot/${fairroot_tag}_fs_$fairsoft_tag#" -i'' CMakeCache.txt
#. ./config.sh
#make install -j$(nproc)

set +xv