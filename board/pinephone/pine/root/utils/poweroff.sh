#!/bin/sh

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
systemctl stop telemetryclient
systemctl stop telemetryserver

#
# Persist wifi connections
#
cp /var/lib/iwd/* /tmp/vault/iwd/
sync

#
# Close vault
#
umount /tmp/vault
/sbin/cryptsetup luksClose volume1

#
# Poweroff
#
/sbin/poweroff -f
exit 0
