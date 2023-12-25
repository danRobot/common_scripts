#! /bin/bash

sleep 120;
level=$(cat /sys/class/power_supply/BAT0/capacity);
limit=15;
discharge="Discharging";
while true
do
    if [ $level -lt $limit ]
    then
        for ln in "$(ps -eo user,args | grep "dbus-daemon.*--session.*--address=" | grep -v grep)";
        do
            user_list="$(echo "$ln" | cut -d' ' -f 1)";
        done
        users=($user_list);
        for user in ${users[@]};
        do
            uid=$(id -u $user);
            bus_addr=unix:path=/run/user/$uid/bus;
            DBUS_SESSION_BUS_ADDRESS="$bus_addr" sudo -u $user -E /usr/bin/notify-send -u critical "Bateria baja el equipo se va a apagar";
        done  
        sleep 60;
        status=$(cat /sys/class/power_supply/BAT0/status);
        if [ $status = $discharge ]
        then
            poweroff;
        fi
        level=$(cat /sys/class/power_supply/BAT0/capacity);
        sleep 60;
    fi
done
