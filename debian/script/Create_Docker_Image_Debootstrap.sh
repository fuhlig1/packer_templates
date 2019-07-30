#!/bin/bash


# Update the installation 
DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
DEBIAN_FRONTEND=noninteractive apt-get -y install debootstrap git apt-transport-https ca-certificates

# Install and start docker
echo "Install and start docker."
DEBIAN_FRONTEND=noninteractive apt-get -y purge lxc-docker*
DEBIAN_FRONTEND=noninteractive apt-get -y purge docker.io*

DEBIAN_FRONTEND=noninteractive apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo debian-jessie main" >> /etc/apt/sources.list.d/docker.list
cat /etc/apt/sources.list.d/docker.list

DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y install docker-engine
service docker start

# Clean up
DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
DEBIAN_FRONTEND=noninteractive apt-get -y clean

## add additionaly sudo to debootstarp needed by packer
cd /usr/share/debootstrap/scripts
sed -e 's/base="apt"/base="apt sudo"/' -i sid
cd -

# create the docker container
git clone https://github.com/docker/docker
cd docker/contrib
./mkimage.sh -t fuhlig1/debian8:base-image debootstrap --variant=minbase jessie

# commit the container
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
docker login 
docker push fuhlig1/debian8:base-image
