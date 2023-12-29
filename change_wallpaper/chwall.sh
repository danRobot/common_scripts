#!/usr/bin/bash

searchPath='IMAGE_FOLDERS'
files=($(find $searchPath -type f));
sleep_time=300;

while [ 1 ]
do
    index=$(($RANDOM % (${#files[@]})))
    for ln in "$(ps -eo user,args | grep "dbus-daemon.*--session.*--address=" | grep -v grep)";
    do
        user_list="$(echo "$ln" | cut -d' ' -f 1)";
    done
    users=($user_list);
    for user in ${users[@]};
    do
        uid=$(id -u $user);
        bus_addr=unix:path=/run/user/$uid/bus;
        DBUS_SESSION_BUS_ADDRESS="$bus_addr" sudo -Hu $user -E /usr/bin/gsettings set org.gnome.desktop.background picture-uri "file:///${files[$index]}";
        DBUS_SESSION_BUS_ADDRESS="$bus_addr" sudo -Hu $user -E /usr/bin/gsettings set org.gnome.desktop.background picture-uri-dark "file:///${files[$index]}";
    done 
    sleep $sleep_time
done

