#!/bin/sh
#
# This is placeholder for vault nuke.
#
# You can use dd or scrub in this script.
#
/opt/tunnel/terminate.sh
systemctl stop telemetryclient.service telemetryserver.service
systemctl stop peer0 peer1 peer2 peer3 peer4 peer5 dpinger
umount /tmp/vault
/sbin/cryptsetup luksClose volume1
# Start nuking
dd if=/dev/zero of=/mnt/vault_0 bs=1024 count=0 seek=$[1024*10]
/bin/scrub -S -f -p dod /etc/systemd/network/wg0.netdev
/bin/scrub -S -f -p dod /etc/systemd/network/wg0.network
/bin/scrub -S -f -p dod /bin/nuke.sh
poweroff --force
exit 0;

