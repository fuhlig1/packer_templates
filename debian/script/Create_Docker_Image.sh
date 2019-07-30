#!/bin/bash


# Update the installation 
DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade

# Clean up
DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
DEBIAN_FRONTEND=noninteractive apt-get -y clean

# Remove temporary files
rm -rf /tmp/*
rm -rf /var/lib/apt/lists/*
rm -rf /opt/*

cat > /usr/sbin/policy-rc.d <<-'EOF'
	#!/bin/sh
	# For most Docker users, "apt-get install" only happens during "docker build",
	# where starting services doesn't work and often fails in humorous ways. This
	# prevents those failures by stopping the services from attempting to start.
	exit 101
EOF
chmod +x /usr/sbin/policy-rc.d

cp -a /usr/sbin/policy-rc.d /sbin/initctl
sed -i 's/^exit.*/exit 0/' /sbin/initctl

# Create a tar file with the system
echo "Create the tar file containing the system."
tar --numeric-owner --exclude=/proc --exclude=/sys -cf debian8-base.tar /

rm /usr/sbin/policy-rc.d
rm /sbin/initctl

# Install and start docker
echo "Install and start docker."
DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y install apt-transport-https ca-certificates

DEBIAN_FRONTEND=noninteractive apt-get -y purge lxc-docker*
DEBIAN_FRONTEND=noninteractive apt-get -y purge docker.io*

DEBIAN_FRONTEND=noninteractive apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo debian-jessie main" >> /etc/apt/sources.list.d/docker.list
cat /etc/apt/sources.list.d/docker.list

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

# Import the system from tar file to docker image
echo "Import tar file with system to docker."
cat debian8-base.tar | docker import - debian8-base

# Tag and upload the image
echo "Upload the docker image to dockerhub."
docker login 
docker tag debian8-base:latest fuhlig1/debian8:base-image
docker push fuhlig1/debian8:base-image

