#!/bin/bash
#
# Record a stream of video from a v4l2 device

CONF="/usr/local/etc/video_monitor.conf"

log () {
	if [ ${LOG} ] ; then
		echo "`date` [ $1 ] : $2" | tee -a ${LOG} ;
	fi
}

source ${CONF}

echo $! > ${PID}

while true ; do

	destanation="${FOLDER}/$(date ${DATE_FORMAT}).${EXTENSION}"

	log INFO "Starting up $0"
	log INFO "Checking to see that ${SOURCE} is not used..."
	retry=0
	while [ ! -z "$(lsof ${SOURCE})" ] && [ $retry -lt 300 ]; do
		echo -n "."
		let "retry = $retry + 1"
		sleep 1
	done

	if [ $retry -gt 0 ]; then
		log WARN "Waited for $retry seconds for device."
	fi
	if [ $retry -ge 300 ]; then
		log ERROR "Processes locking ${SOURCE}: $(lsof ${SOURCE})"
		log ERROR "Timed out, quitting."
		exit 1
	fi

	log INFO "Recording with VLC for ${DURATION} seconds, output at $destanation, VLC console output below:"
	time timeout ${DURATION} /usr/local/bin/vlc ${DEBUG_OPTS} -I dummy v4l2:// \
		:v4l2-dev=${SOURCE} \
		:v4l2-width=${RES_X} \
		:v4l2-height=${RES_Y} \
		--sout-mux-caching 8192 \
		--sout="#transcode{vcodec=${VCODEC}}:duplicate{dst=std{access=file,dst=$destanation},dst=std{access=http{user=${HTTP_USER},pwd=${HTTP_PWD},mime=video/mp4},dst=${HTTP_IP}:${HTTP_PORT}/${HTTP_NAME},mux=ps,name=${HTTP_NAME}},{select=noaudio}}" 2>&1 | tee -a ${LOG}
		# --run-time=3600 # Does not work with streams, we are timing out the process with bash instead:
		# <http://stackoverflow.com/questions/18013503/capture-video-from-vlc-command-line-with-a-stop-time>

	log INFO "Finished recording, done."
	log INFO "Triggering a cleanup..."
	truncate -s 10240000 ${LOG} &
	find ${FOLDER} -name "*.${EXTENSION}" -ctime +${RETENTION} -delete &
done

log INFO "Shutting down."
rm -f ${PID}
exit 0
