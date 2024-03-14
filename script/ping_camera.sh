#!/bin/bash

data=($( mysql -u root -pdic2727175 -D stream -e "select ip from camera;" -B -N ))

for ip in ${data[@]}
do
	ffprobe -show_streams -i "rtsp://admin:Dic2727175@${ip}:554/1/h264major" -v quiet &> /dev/null; a=$?
	ffprobe -show_streams -i "rtsp://admin:Dic2727175@${ip}:80/stream0"      -v quiet &> /dev/null; b=$?
	ffprobe -show_streams -i "rtsp://admin:Dic2727175@${ip}:554/live/ch00_1" -v quiet &> /dev/null; c=$?

	if [[ ${a} -eq 0 ]] || [[ ${b} -eq 0 ]] || [[ ${c} -eq 0 ]];then
		echo "${ip} ok"
		mysql -u root -pdic2727175 -D stream -e "UPDATE camera SET status='normal' WHERE ip='${ip}';"
	else
		echo "${ip} no"
		mysql -u root -pdic2727175 -D stream -e "UPDATE camera SET status='error' WHERE ip='${ip}';"
	fi
done
