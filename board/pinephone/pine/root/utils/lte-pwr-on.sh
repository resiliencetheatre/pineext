#!/bin/sh
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
exit 0
fi
echo "Missing: /dev/ttyUSB2"
exit 1
