#! /bin/bash

DEST_PATH=$1;
IMAGE_FOLDERS=$2;

IMAGE_FOLDERS=${IMAGE_FOLDERS////\\/};

cp chwall.sh $DEST_PATH;
DEST_PATH=$DEST_PATH'chwall.sh';
sed -i 's/IMAGE_FOLDERS/'$IMAGE_FOLDERS'/g' $DEST_PATH;

cp change_wallpaper.service /etc/systemd/system/;

DEST_PATH=${DEST_PATH////\\/};

sed -i 's/SCRIPT_PATH/'$DEST_PATH'/g' /etc/systemd/system/change_wallpaper.service;

systemctl daemon-reload
systemctl enable change_wallpaper.service
systemctl start change_wallpaper.service
systemctl status change_wallpaper.service
