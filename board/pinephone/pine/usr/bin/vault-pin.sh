#!/bin/sh

#
# make directories if needed
#

if [ ! -d "/tmp/vault" ]; 
then
 mkdir /tmp/vault
fi

if [ ! -d "/opt/wgcap" ]; 
then
 mkdir /opt/wgcap
fi

if [ -e /tmp/tx-key-presentage ]
then
 rm /tmp/tx-key-presentage
fi

if [ -e /tmp/rx-key-presentage ]
then
 rm /tmp/rx-key-presentage
fi

if [ -e /tmp/message_fifo_out ]
then
 rm /tmp/message_fifo_out
fi

if [ -e /tmp/telemetry_fifo_in ]
then
 rm /tmp/telemetry_fifo_in
fi

if [ -e /tmp/telemetry_fifo_out ]
then
 rm /tmp/telemetry_fifo_out
fi


#
# Hotswap vs open vault
#
# NOTE: Hotswap is not yet implemented
#

if [ -e /tmp/vault/sinm.ini ]
then
#
# Vault is open => close it
#

#
# Remove WG configurations
#
rm /etc/systemd/network/wg0.*

#
# Stop services
#
systemctl stop systemd-networkd
systemctl stop rtptun.service
systemctl stop udp2raw.service
systemctl stop peer?.service
systemctl stop dpinger.service
systemctl stop glorytun.service
systemctl stop audio*.service
systemctl stop connect-with*.service

#
# Remove services
#
rm /etc/systemd/system/audioreceive.service
rm /etc/systemd/system/audiostreamer*.service
rm /etc/systemd/system/connect-with*.service
rm /etc/systemd/system/peer?.service
rm /etc/systemd/system/proftp*.service
rm /etc/systemd/system/rtptun.service
rm /etc/systemd/system/telemetryserver-as-otp-server.service
rm /etc/systemd/system/telemetryserver-as-otp-client.service
rm /etc/systemd/system/udp2raw.service

#
# Close vault
#
umount /tmp/vault
/sbin/cryptsetup luksClose volume1

fi

#
# Pin to vault key (from UI) & luksOpen /mnt/vault_X => volume1
#
# NOTE: Pin to LUKS password is placeholder only. Modify this based on
#       your threat model!
#
VAULT_INDEX=$2
echo $1 | sha256sum | cut -d" " -f1 > /tmp/vaultkey
/sbin/cryptsetup luksOpen --key-file /tmp/vaultkey /mnt/vault_${VAULT_INDEX} volume1

#
# Evaluate cryptsetup return value, do not output anything if failed.
#

if [ $? -eq 0 ]; 
then
echo "Valid pin!" 
rm /tmp/vaultkey

#
# Mount vault to mount point
#
mount /dev/mapper/volume1 /tmp/vault

#
# Init new instance from vault to rootfs
#
cp /opt/tunnel/network-configurations/wg0.* /etc/systemd/network/
cp /opt/tunnel/service-files/* /etc/systemd/system/
cp /opt/tunnel/wgcap_service.conf /opt/wgcap
ln -s /etc/systemd/system/rtptun.service /etc/systemd/system/multi-user.target.wants
cp /etc/ringtone.wav /opt/tunnel/ringtone.wav

#
# Reload systemd
#
systemctl daemon-reload
# NOTE: Adjust this based on your primary tunneling.
systemctl start rtptun
systemctl restart systemd-networkd
sleep 1

#
# Start UI (and rest of the services)
#
systemctl start ui
exit 0

else
 exit 2
fi

