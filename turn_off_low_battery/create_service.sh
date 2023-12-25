#! /bin/bash

DEST_PATH=$1;

cp sec_poweroff.sh $DEST_PATH;
DEST_PATH=$DEST_PATH'sec_poweroff.sh';

cp sec_poweroff.service /etc/systemd/system/;

DEST_PATH=${DEST_PATH////\\/};

sed -i 's/SCRIPT_PATH/'$DEST_PATH'/g' /etc/systemd/system/sec_poweroff.service;

systemctl daemon-reload
systemctl enable sec_poweroff.service
systemctl start sec_poweroff.service
systemctl status sec_poweroff.service
