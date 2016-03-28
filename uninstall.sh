#!/bin/bash

APP_NAME="video_monitor"
PREFIX="/usr/local"
WWW_ROOT="/var/www/htdocs"

echo "Uninstalling video_monitor:"

source ${PREFIX}/etc/${APP_NAME}.conf

function
if [ "${FOLDER}" ]; then
	echo -n "Delete everything from ${FOLDER} ? (y/n)"
	read confirm
	if [ $confirm == "y" ]; then
		rm -v -r -f ${FOLDER}
	else
		echo " ... OK, leaving videos @ ${FOLDER} ."
	fi
fi

rmdir -v ${FOLDER} ${PREFIX}/bin ${PREFIX}/etc ${WWW_ROOT}

rm -vf ${PREFIX}/bin/${APP_NAME}.sh
rm -vf ${WWW_ROOT}/${APP_NAME}.php
rm -vf ${WWW_ROOT}/${APP_NAME}
rm -vi ${PREFIX}/etc/${APP_NAME}.conf

echo "Done."
