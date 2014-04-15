#!/bin/bash


while [ 1 ]; do
    sleep 5
    cpuTemp=$(cat /sys/class/thermal/thermal_zone0/temp)
    if [ "$cpuTemp" -ge 60000 ]; then
        $(date >> /root/logs/thermalShutdown.log)
        $(echo "Temperature was $cpuTemp" >> /root/logs/thermalShutdown.log)
        echo "8" > /sys/class/gpio/export
        echo "out" > /sys/class/gpio/gpio8/direction
        echo "1" > /sys/class/gpio/gpio8/value
        sleep 1
        systemctl poweroff
    fi
done
