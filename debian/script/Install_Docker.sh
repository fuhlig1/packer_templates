#!/bin/bash

# Update the installation 
DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

# Clean up
DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
DEBIAN_FRONTEND=noninteractive apt-get -y clean

# Remove temporary files
rm -rf /tmp/*

# Create a tar file with the system
#tar --numeric-owner --exclude=/proc --exclude=/sys -cvf debian8-base.tar /
tar --numeric-owner --exclude=/proc -cf debian8-base.tar /

# Install and start docker
DEBIAN_FRONTEND=noninteractive apt-get -y purge lxc-docker*
DEBIAN_FRONTEND=noninteractive apt-get -y purge docker.io*
DEBIAN_FRONTEND=noninteractive apt-get -y install apt-transport-https ca-certificates
DEBIAN_FRONTEND=noninteractive apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo debian-jessie main" >> /etc/apt/sources.list.d/docker.list
DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y install docker-engine
service docker start

mkdir -p $HOME/.docker
cat > $HOME/.docker/config.json << EOF
{
        "auths": {
                "https://index.docker.io/v1/": {
                        "auth": "ZnVobGlnMTppbmxpbmU3MQ=="
                }
        }
}
EOF

echo ""
# Import the system from tar file to docker image
echo "Create tar file with system."
cat debian8-base.tar | docker import - debian8-base

# Tag and upload the image
docker login 
docker tag debian8-base:latest fuhlig1/debian8:base-image
docker push fuhlig1/debian8:base-image

