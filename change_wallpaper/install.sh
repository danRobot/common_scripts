#! /bin/bash

if [ -z "$1" ]; then
    echo "❌ Error: No se proporcionó una ruta de destino."
    echo "Uso: $0 /ruta_de_instalacion_absoluta/"
    exit 1 # Termina el script con un código de error
fi

if [ -z "$2" ]; then
    echo "❌ Error: No se proporcionó una ruta de loas fondos de pantalla."
    echo "Uso: $0 /ruta_de_absoluta_fondos/"
    exit 1 # Termina el script con un código de error
fi

DEST_PATH=$1;
IMAGE_FOLDERS=$2;

if [ ! -d "$DEST_PATH" ]; then
    echo "❌ Error: La ruta '$DEST_PATH' no es un directorio válido o no existe."
    exit 1 # Termina el script con un código de error
fi

if [ ! -d "$IMAGE_FOLDERS" ]; then
    echo "❌ Error: La ruta '$IMAGE_FOLDERS' no es un directorio válido o no existe."
    exit 1 # Termina el script con un código de error
fi

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
