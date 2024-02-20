#!/usr/bin/bash

searchPath='IMAGE_FOLDERS'
sleep_time=300;

while [ 1 ]
do
    for ln in "$(ps -eo user,args | grep "dbus-daemon.*--session.*--address=" | grep -v grep)";
    do
        user_list="$(echo "$ln" | cut -d' ' -f 1)";
    done
    users=($user_list);
    for user in ${users[@]};
    do
        uid=$(id -u $user);
        bus_addr=unix:path=/run/user/$uid/bus;
        file=$(find $searchPath -type f | shuf -n 1);
        DBUS_SESSION_BUS_ADDRESS="$bus_addr" sudo -Hu $user -E /usr/bin/gsettings set org.gnome.desktop.background picture-uri "file:///$file";
        DBUS_SESSION_BUS_ADDRESS="$bus_addr" sudo -Hu $user -E /usr/bin/gsettings set org.gnome.desktop.background picture-uri-dark "file:///$file";
    done 
    sleep $sleep_time
done

