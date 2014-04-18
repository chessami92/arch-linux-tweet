#!/bin/bash


while [ 1 ]; do
    sleep 5
    cpuTemp=$(cat /sys/class/thermal/thermal_zone0/temp)
    if [ "$cpuTemp" -ge 60000 ]; then
        $(date >> /root/logs/thermalShutdown.log)
        $(echo "Temperature was $cpuTemp" >> /root/logs/thermalShutdown.log)
        echo "14" > /sys/class/gpio/export
        echo "out" > /sys/class/gpio/gpio14/direction
        echo "0" > /sys/class/gpio/gpio14/value
        sleep 1
        systemctl poweroff
    fi
done
