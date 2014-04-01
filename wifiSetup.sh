#!/bin/bash

WIFI_DIR=/etc/netctl/wlan0-*

for filename in $WIFI_DIR; do
    wlan=$(basename "$filename" )
    echo "Stopping $wlan."
    netctl stop $wlan
done

ip link set wlan0 up

for filename in $WIFI_DIR; do
    wlan=$(basename "$filename" )
    echo "Trying $wlan"
    netctl start $wlan
    if [ $? == 0 ]; then
        break;
    fi
done

/usr/bin/ntpd -gq > /dev/null

