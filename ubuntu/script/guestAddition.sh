#!/bin/sh

mkdir -p /mnt/virtualbox
mount -o loop /home/fairroot/VBoxGuest*.iso /mnt/virtualbox
sh /mnt/virtualbox/VBoxLinuxAdditions.run
umount /mnt/virtualbox
rm -rf /home/fairroot/VBoxGuest*.iso
