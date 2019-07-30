#!/bin/bash

#cat > /usr/sbin/policy-rc.d <<-'EOF'
        #!/bin/sh
        # For most Docker users, "apt-get install" only happens during "docker build",
        # where starting services doesn't work and often fails in humorous ways. This
        # prevents those failures by stopping the services from attempting to start.
#        exit 101
#EOF
#chmod +x /usr/sbin/policy-rc.d

DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

DEBIAN_FRONTEND=noninteractive apt-get -y install \
                   cmake cmake-data g++ gcc gfortran \
                   debianutils build-essential make patch sed \
                   libx11-dev libxft-dev libxext-dev libxpm-dev libxmu-dev \
                   libglu1-mesa-dev libgl1-mesa-dev \
                   ncurses-dev curl libcurl4-openssl-dev bzip2 libbz2-dev gzip unzip tar \
		   subversion git xutils-dev flex bison lsb-release python-dev \
		   libc6-dev-i386 libxml2-dev wget libssl-dev libkrb5-dev \
                   automake autoconf libtool

DEBIAN_FRONTEND=noninteractive apt-get -y clean
DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
