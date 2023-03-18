#!/bin/sh
#
# Manual LTE connect
#

if [[ ! -f /root/utils/apn.env ]]
then
    APN="internet"
    echo "No /root/utils/apn.env found. Using default APN: ${APN}"
fi

if [[ -f /root/utils/apn.env ]]
then
    source /root/utils/apn.env
    echo "Found: /root/utils/apn.env, using APN: ${APN}"
fi

MODEM_POWER=$(cat /sys/class/modem-power/modem-power/device/powered)

if [ $MODEM_POWER -eq "0" ]
then
 echo "Modem is OFF, doing power up"
 echo 1 > /sys/class/modem-power/modem-power/device/powered
 sleep 40

 if [ -c /dev/ttyUSB2 ]
 then
  echo -ne "at\r" > /dev/ttyUSB2
  sleep 1
  echo -ne "AT+QCFG=\"airplanecontrol\",0\r" > /dev/ttyUSB2
  sleep 1
  echo -ne "at+cfun=1\r" > /dev/ttyUSB2
  echo "Modem powered on"
 else
  echo "Cannot find /dev/ttyUSB2 ? Exiting.."
  exit 1
 fi

fi

# check link layer protocol 
# qmicli --device=/dev/cdc-wdm0 --device-open-proxy --wda-get-data-format

#
# Interface down & apply raw_ip
#
ip link set dev wwan0 down
cat /sys/class/net/wwan0/qmi/raw_ip
echo Y > /sys/class/net/wwan0/qmi/raw_ip
#
# Interface up, connect and get IP with dhcp
#
ip link set dev wwan0 up
sleep 2
qmicli --device=/dev/cdc-wdm0 --device-open-proxy --wds-start-network="ip-type=4,apn=${APN}" --client-no-release-cid
sleep 2
udhcpc -q -f -n -i wwan0
echo " "
echo "Ready"
exit 0

#
# iptables to route between usb0 and wwan0
#
# echo 1 > /proc/sys/net/ipv4/ip_forward
# iptables -P INPUT ACCEPT
# iptables -P FORWARD ACCEPT
# iptables -P OUTPUT ACCEPT
# iptables -t nat -F
# iptables -t mangle -F
# iptables -F
# iptables -X
# WANINTERFACE=wwan0
# USBINTERFACE=usb0
#iptables -A FORWARD -i $USBINTERFACE -o $WANINTERFACE -j ACCEPT
#iptables -A FORWARD -i $WANINTERFACE -o $USBINTERFACE -m state --state ESTABLISHED,RELATED \
#         -j ACCEPT
#iptables -t nat -A POSTROUTING -o $WANINTERFACE -j MASQUERADE
#
