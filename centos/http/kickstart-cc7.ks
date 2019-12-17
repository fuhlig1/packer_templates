##############################################################################
#
# Example KickStart file for CC7 installations
#
# Important note: this file is intended as an example only, and users are 
# expected to tailor it to their needs. In particular, users should:
#   - review the partition table
#   - set an encrypted root password
#
# To upload the Kickstart file to the AIMS installation service, run:
#
#     /usr/bin/aims2client addhost --hostname <hostname> \
#                          --kickstart kickstart-example.ks \
#                          --pxe --name cc7_x86_64
#
##############################################################################

# Text mode or graphical mode?
text
# Install or upgrade?
install
# System authorization information
auth --enableshadow --passalgo=sha512
# SElinux
selinux --enforcing
# Use network installation
url --url="http://linuxsoft.cern.ch/cern/centos/7/os/x86_64/"
# Firewall configuration
#firewall --enabled --port=7001:udp,4241:tcp --service=ssh
# Run the Setup Agent on first boot (the post section replaces firsboot 
# for non-interactive installations
firstboot --disable
# Keyboard layouts
# old format: keyboard us
# new format:
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp  --ipv6=auto --activate
# Root password (use "grub-md5-crypt" to get the crypted version)
rootpw --plaintext FairRoot
user --name=fairroot --groups=fairroot --password=FairRoot --plaintext
# System timezone
timezone Europe/Berlin
# X Window System configuration information
#xconfig  --startxonboot
# System bootloader configuration: PLEASE REVIEW
#bootloader --location=mbr --boot-drive=vda
bootloader --timeout=1
#--boot-drive=sda
# Partitioning information: PLEASE REVIEW
clearpart --all --initlabel 
autopart
# Reboot after installation?
reboot

#
# You can list groups with "yum list group -v"
#
%packages
@core
which
sudo
openssh-server
bzip2
kernel-devel
make
redhat-lsb-core
-firewalld
-kernel
-NetworkManager
-plymouth
%end

%post

#
# This section describes all the post-Anaconda steps to fine-tune the installation
#

# redirect the output to the log file
exec >/root/ks-post-anaconda.log 2>&1
# show the output on the 7th console
tail -f /root/ks-post-anaconda.log >/dev/tty7 &
# changing to VT 7 that we can see what's going on....
/usr/bin/chvt 7

#
# Set the correct time
#
#/usr/sbin/ntpdate -bus ip-time-1 ip-time-2
#/sbin/clock --systohc

#
# AIMS (CERN)
# Tell our installation server the installation is over.
# otherwise PXE installs will loop all-over-again
# If you are not using PXE install: just ignore this section
#
#/usr/bin/wget -O /root/aims2-deregistration.txt http://linuxsoft.cern.ch/aims2server/aims2reboot.cgi?pxetarget=localboot

#
# Save the Kickstart file for future reference
#
# Note: this assumes that the Kickstart-file uploaded to AIMS is called <hostname>.ks
#
#shost=`/bin/hostname -s`
#/usr/bin/wget -O /root/${shost}.ks --quiet http://linuxsoft.cern.ch/aims2server/aims2ks.cgi\?${shost}.ks
#
#
# Configuration steps, based on
# http://cern.ch/linux/centos7/docs/install.shtml#manualpostinst
#
#/usr/sbin/lcm --configure --all
# starting with CC 7.3: locmap replaces lcm

# These are the core modules enabled by default on a interactive install.
#/usr/bin/locmap --enable afs
#/usr/bin/locmap --enable kerberos
#/usr/bin/locmap --enable lpadmin
#/usr/bin/locmap --enable nscd
#/usr/bin/locmap --enable ntp
/usr/bin/locmap --enable sendmail
/usr/bin/locmap --enable ssh
/usr/bin/locmap --enable sudo
#/usr/bin/locmap --enable eosclient
#/usr/bin/locmap --enable cvmfs

/usr/bin/locmap --configure all

# Add AFS client to system startup, and start it:
#/usr/bin/systemctl enable openafs-client
#/usr/bin/systemctl start openafs-client

# Configure automatic update system:
/usr/bin/systemctl enable yum-autoupdate

# Create accounts for LANdb-registered responsible and main users, give responsible
# root access, configure relevant printers
# Can not be added to %packages section due to dependencies from EPEL,install now
#/usr/bin/yum -y install cern-config-users
#/usr/sbin/cern-config-users --setup-all

cat <<EOF > /etc/sudoers.d/fairroot
Defaults:fairroot !requiretty
fairroot ALL=(ALL) NOPASSWD: ALL
EOF
chmod 440 /etc/sudoers.d/fairroot

mkdir -p /etc/systemd/network
ln -sf /dev/null /etc/systemd/network/99-default.link
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
DEVICE="eth0"
BOOTPROTO="dhcp"
ONBOOT="yes"
TYPE="Ethernet"
EOF

# Done
exit 0

%end
