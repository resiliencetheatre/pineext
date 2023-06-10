#!/bin/bash
#
# burnusbdrive - USB drive creation tool for oobcomm devices.
#
# Copyright (C) 2023 Resilience Theatre
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA.
#
#

#
# Select which vault file to use
#
SOURCE_VAULT=vault_0
LABEL_CALLSIGN_NAME=[call sign]

#
# Define target USB device, be careful with this!
#
TARGET_DEV=[target device]

#
# Define where vault files are located
#
VAULT_SOURCE_PATH=[vault source path]

#
# OS Image ${OS_IMAGE}
#
OS_IMAGE=[os image file]

#
# 
#
check_usb_device() {
    local device_path=$1
    for devlink in /dev/disk/by-id/usb*; do
     if [ "$(readlink -f "$devlink")" = "$device_path" ]; then
      return 0
     fi
    done
    return 1
}

#
# Check file presense
#
if [[ ! -f ${OS_IMAGE} ]]
then
    echo "${OS_IMAGE} cannot be found. Exiting."
    exit
fi

if [[ ! -f "${VAULT_SOURCE_PATH}/${SOURCE_VAULT}" ]]
then
    echo "${VAULT_SOURCE_PATH}/${SOURCE_VAULT} cannot be found. Exiting."
    exit
fi

#
# Checking target block device
#
if [[ ! -b ${TARGET_DEV} ]]
then
    echo "Target device: ${TARGET_DEV} cannot be found. Exiting."
    exit
fi

#
# Check root
#
if [ "$EUID" -ne 0 ]
  then echo "Please run with sudo:  sudo ./burnusbdrive.sh "
  exit
fi

#
# Ask confirmation
#
echo " "
echo " "
echo "Source OS image:      ${OS_IMAGE} "
echo "Source vault:         ${VAULT_SOURCE_PATH}/${SOURCE_VAULT}"
echo "Target block device:  ${TARGET_DEV}"

if check_usb_device ${TARGET_DEV}; then
echo "Checking target type: ${TARGET_DEV} is a removable usb device"
else
echo "Checking target type: ${TARGET_DEV} is not a usb device, aborting!"
exit
fi

echo " "
read -p "Press any key to continue... " -n1 -s

TIMESTAMP=$(date +%d-%m-%Y_%H-%M-%S)
echo " "
echo "$TIMESTAMP Start"


#
# Burn USB drive
#
umount /run/media/tech/* > /dev/null 2>&1
sudo umount /tmp/usbmount > /dev/null 2>&1
echo "$TIMESTAMP Deleting partition data"
sudo sfdisk --delete $TARGET_DEV > /dev/null 2>&1
sleep 5

TIMESTAMP=$(date +%d-%m-%Y_%H-%M-%S)
echo "$TIMESTAMP Starting copy"
sudo dd if=${OS_IMAGE} of=$TARGET_DEV status=progress
sync;

TIMESTAMP=$(date +%d-%m-%Y_%H-%M-%S)
echo "$TIMESTAMP Image burn completed!"
echo "$TIMESTAMP Creating data partition for vault file..."

#
# Create additional partition and mount it for vault file
# NOTE size: 600 is pine image
#
sudo parted --script $TARGET_DEV 'mkpart primary ext4 600 -1' > /dev/null 2>&1
sleep 1
sudo mkfs.ext4 -L ${LABEL_CALLSIGN_NAME} -F -F ${TARGET_DEV}3 > /dev/null 2>&1
sleep 1
mkdir /tmp/usbmount
sudo mount ${TARGET_DEV}3 /tmp/usbmount

TIMESTAMP=$(date +%d-%m-%Y_%H-%M-%S)
echo "$TIMESTAMP Data partition created and mounted. Copying vault file."

#
# Copy vault 
# NOTE: File name on USB drive has to be 'vault_0' 
#
sudo cp ${VAULT_SOURCE_PATH}/${SOURCE_VAULT} /tmp/usbmount/vault_0
sync

TIMESTAMP=$(date +%d-%m-%Y_%H-%M-%S)
echo "$TIMESTAMP Copy completed."

#
# Clean up
#
sudo umount /tmp/usbmount

if [ -d "/tmp/usbmout/" ]
then
	if [ "$(ls -A /tmp/usbmout/)" ]; then
     sudo rm /tmp/usbmout/*
	else
 	 rmdir /tmp/usbmount/
	fi
fi

TIMESTAMP=$(date +%d-%m-%Y_%H-%M-%S)
echo "$TIMESTAMP USB drive unmounted. You can unplug it now."
echo " "






