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

# check cmake version
cmake_version_string=$(cmake --version | sed -n 1p)
cmake_installed_major_version=$(echo $cmake_version_string | cut -d' '  -f3 | cut -d. -f1)
cmake_installed_minor_version=$(echo $cmake_version_string | cut -d. -f2)
cmake_installed_patch_version=$(echo $cmake_version_string | cut -d. -f3)
if [ $cmake_installed_minor_version -lt 11 ]; then
  export PATH=/opt/fairsoft/${fairsoft_tag}_root${root_version}/bin:$PATH
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
if [ -e /opt/cbmroot/source/fieldmaps/field_v12b.root ]; then ln -s /opt/cbmroot/source/fieldmaps/field_v12b.root; fi
if [ -e /opt/cbmroot/source/fieldmaps/field_v12a.root ]; then ln -s /opt/cbmroot/source/fieldmaps/field_v12a.root; fi
if [ -e /opt/cbmroot/source/fieldmaps/field_v16a.root ]; then ln -s /opt/cbmroot/source/fieldmaps/field_v16a.root; fi
if [ -e /opt/cbmroot/source/fieldmaps/field_v18a.root ]; then ln -s /opt/cbmroot/source/fieldmaps/field_v18a.root; fi

cd /opt/cbmroot/source/cbmroot_$cbmroot_tag

distributor=$(lsb_release -is | cut -f1 -d' ')
release=$(lsb_release -rs)
flavour=$distributor$release
ccomp=$(/opt/fairsoft/${fairsoft_tag}_root${root_version}/bin/fairsoft-config --cc)
cppcomp=$(/opt/fairsoft/${fairsoft_tag}_root${root_version}/bin/fairsoft-config --cxx)

cat > Dart.cfg << EOF
export LINUX_FLAVOUR=$flavour
export FAIRSOFT_VERSION=${fairsoft_tag}_root${root_version}
export SIMPATH=/opt/fairsoft/${fairsoft_tag}_root${root_version}
export FAIRROOT_VERSION=$fairroot_tag
export FAIRROOTPATH=/opt/fairroot/${fairroot_tag}_fs_${fairsoft_tag}_root${root_version}
export CC=$ccomp
export CXX=$cppcomp
export BUILDDIR=/opt/cbmroot/source/cbmroot_$cbmroot_tag/build
export SOURCEDIR=/opt/cbmroot/source/cbmroot_$cbmroot_tag
EOF

if [ -d /opt/compiler/gcc ]; then
cat >> Dart.cfg << EOF
export EXTRA_FLAGS="-DUSE_PATH_INFO=TRUE"
EOF
fi

sleep 3s

cat ./Dart.cfg

sleep 3s

./Dart.sh Nightly ./Dart.cfg

set +xv