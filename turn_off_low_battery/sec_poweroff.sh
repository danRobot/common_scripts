#! /bin/bash

# Script to monitor battery level and shut down the system if it falls below a critical threshold.
# define variables
sleep_time=60;
limit=16;
critical_limit=5;
discharge="Discharging";
normal_message="Bateria baja el equipo se va a apagar";
critical_message="Bateria critica el equipo se va a apagar inmediatamente";

# Function to send desktop notifications to all logged-in users
function alert_user {
    for ln in "$(ps -eo user,args | grep "dbus-daemon.*--session.*--address=" | grep -v grep)";
    do
        user_list="$(echo "$ln" | cut -d' ' -f 1)";
    done
    users=($user_list);
    for user in ${users[@]};
    do
        uid=$(id -u $user);
        bus_addr=unix:path=/run/user/$uid/bus;
        DBUS_SESSION_BUS_ADDRESS="$bus_addr" sudo -u $user -E /usr/bin/notify-send -u critical "$1";
    done
}

# Continuous monitoring loop
while true
do
    level=$(cat /sys/class/power_supply/BAT0/capacity);
    status=$(cat /sys/class/power_supply/BAT0/status);
    # Check battery critical level
    if [ $level -lt $critical_limit ]
    then
        if [ "$status" = $discharge ]
        then
            alert_user "$critical_message";
            python3 SCRIPT_PATH;
            sleep 3;
            poweroff;
        fi
    fi
    if [ $level -lt $limit ]
    then
        if [ "$status" = $discharge ]
        then
            alert_user "$normal_message";
        fi
        sleep $sleep_time;
        status=$(cat /sys/class/power_supply/BAT0/status);
        if [ "$status" = $discharge ]
        then
            python3 SCRIPT_PATH;
            sleep 3;
            poweroff;
        fi
    fi
    sleep $sleep_time;
done
