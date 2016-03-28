#!/bin/bash

APP_NAME="video_monitor"
PREFIX="/usr/local"
WWW_ROOT="/var/www/htdocs"

echo "Installing video_monitor:"

source etc/${APP_NAME}.conf

mkdir -vp ${FOLDER} ${PREFIX}/bin ${PREFIX}/etc ${WWW_ROOT}
ln -vsf ${FOLDER} ${WWW_ROOT}/${APP_NAME}

cp -vpf bin/${APP_NAME}.sh ${PREFIX}/bin/
cp -vpf var/www/htdocs/${APP_NAME}.php ${WWW_ROOT}
cp -vpf etc/${APP_NAME}.conf ${PREFIX}/etc/

echo "Done."
