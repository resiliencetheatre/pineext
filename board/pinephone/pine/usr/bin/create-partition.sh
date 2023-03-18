#!/bin/sh
if [ -d "/mnt/lost+found" ] 
then
    echo "/mnt partition found!" 
else
    echo "Creating third partition"
    TARGET_DEV=/dev/sda
    parted --script $TARGET_DEV 'mkpart primary ext4 570 -1'
    mkfs.ext4 -F -F ${TARGET_DEV}3
fi
exit 0
