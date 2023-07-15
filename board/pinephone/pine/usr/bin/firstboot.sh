#!/bin/sh
if [ -e "/etc/fbc" ] 
then
    	echo "First boot is already done." 
else
	echo "Disabling systemd-networkd-wait-online.service"
	/bin/systemctl disable systemd-networkd-wait-online.service
	echo "Disabling proftpd service"
	/bin/systemctl disable proftpd.service
	echo "Disabling journaling"
	/bin/systemctl disable systemd-journald.service
	/bin/systemctl mask systemd-journald.service
    	echo "This is first boot!"
    	cp /opt/tunnel/network-configurations/wg0.* /etc/systemd/network/
    	cp /opt/tunnel/service-files/* /etc/systemd/system/
	mkdir /opt/wgcap
	cp /opt/tunnel/wgcap_service.conf /opt/wgcap
	ln -s /etc/systemd/system/rtptun.service /etc/systemd/system/multi-user.target.wants/
	# ringtone
	cp /etc/ringtone.wav /opt/tunnel/ringtone.wav
    	touch /etc/fbc
    	sync
    	reboot --force
fi
exit 0
