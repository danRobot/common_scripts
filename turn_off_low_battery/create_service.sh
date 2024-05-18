#! /bin/bash

DEST_PATH=$1;

cp sec_poweroff.sh $DEST_PATH;
cp ../automatic_umount_disks/shtdwn_custom_script.py $DEST_PATH;
DEST_PATH_UMOUNT=$DEST_PATH'shtdwn_custom_script.py';
DEST_PATH=$DEST_PATH'sec_poweroff.sh';

cp sec_poweroff.service /etc/systemd/system/;

DEST_PATH_COPY=$DEST_PATH;
DEST_PATH=${DEST_PATH////\\/};
DEST_PATH_UMOUNT=${DEST_PATH_UMOUNT////\\/};

sed -i 's/SCRIPT_PATH/'$DEST_PATH'/g' /etc/systemd/system/sec_poweroff.service;
sed -i 's/SCRIPT_PATH/'$DEST_PATH_UMOUNT'/g' $DEST_PATH_COPY;

systemctl daemon-reload
systemctl enable sec_poweroff.service
systemctl start sec_poweroff.service
systemctl status sec_poweroff.service
