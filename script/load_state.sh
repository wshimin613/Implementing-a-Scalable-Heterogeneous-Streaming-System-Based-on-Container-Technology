#!/bin/bash

container_ip=($( podman ps --format "{{.Names}}" | grep 'stream' | cut -d '_' -f 2 ))
stream_info=()

for ip in "${container_ip[@]}"
do
	stream_name=$( ps -aux | grep '/bin/ffmpeg' | grep "192.168.3.${ip}" | awk -F '/' '{print $NF}' )
	camera_name=$( mysql -u root -pdic2727175 -D stream -e "select name from camera where container_ip="${ip}";" -B -N )
	action=$( mysql -u root -pdic2727175 -D stream -e "select action from camera where container_ip="${ip}";" -B -N )
	stream_info+=("{\"streamName\":\"${stream_name}\",\"cameraName\":\"${camera_name}\",\"action\":\"${action}\",\"container_ip\":\"${ip}\"}")
done

stream_info_json=$(printf '%s\n' "${stream_info[@]}" | jq -s .)
echo ${stream_info_json}
