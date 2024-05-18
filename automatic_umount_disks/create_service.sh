#! /bin/bash

DEST_PATH=$1;

cp shtdwn_custom_script.py $DEST_PATH;
DEST_PATH=$DEST_PATH'shtdwn_custom_script.py';
chmod +x $DEST_PATH


cp automatic_umount.service /etc/systemd/system/;

DEST_PATH=${DEST_PATH////\\/};

sed -i 's/SCRIPT_PATH/'$DEST_PATH'/g' /etc/systemd/system/automatic_umount.service;

systemctl daemon-reload
systemctl enable automatic_umount.service
systemctl start automatic_umount.service
systemctl status automatic_umount.service
