#!/bin/sh
sleep 1
echo s2idle > /sys/power/mem_sleep
echo mem > /sys/power/state
exit 0
