#! /bin/bash

if [ -z "$1" ]; then
    echo "❌ Error: No se proporcionó una ruta de destino."
    echo "Uso: $0 /ruta_de_instalacion_absoluta/"
    exit 1 # Termina el script con un código de error
fi

DEST_PATH=$1;

if [ ! -d "$DEST_PATH" ]; then
    echo "❌ Error: La ruta '$DEST_PATH' no es un directorio válido o no existe."
    exit 1 # Termina el script con un código de error
fi

sudo apt-get install -y libnotify-bin

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
