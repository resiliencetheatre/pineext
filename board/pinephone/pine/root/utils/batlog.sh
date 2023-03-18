#!/bin/sh
#
# Log and monitor battery, cell and backlight state in development.
#
# Based on https://syndicate-lang.org/journal/2022/01/07/pinephone-battery-discharge-curve
#
while true
do
 CHARGER=`cat /sys/class/power_supply/axp20x-battery/status`
 BACKLIGHT=`cat /sys/class/backlight/backlight/brightness`
 ENVFILE=`cat /tmp/env`
 CAPACITY=`cat /sys/class/power_supply/axp20x-battery/capacity`
 echo "$(date +"%FT%H:%M:%S"),${CAPACITY},${ENVFILE},${BACKLIGHT},${CHARGER}"
 sleep 60
 sync
done | tee -a /root/env.log
exit 0
