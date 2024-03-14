#!/bin/bash

stream_ip=${1}
stream_URL=(
    "rtsp://admin:Dic2727175@${stream_ip}:554/1/h264major"
    "rtsp://admin:Dic2727175@${stream_ip}:80/stream0"
    "rtsp://admin:Dic2727175@${stream_ip}:554/live/ch00_1"
)

found=false
for url in "${stream_URL[@]}"
do
        encoder=$( timeout 4 ffprobe -show_streams -i ${url} -v quiet | grep -Po 'codec_name=\K\w+' ); state=$?
        if [[ ${state} -eq 0 ]]; then
		found=true
                break
        fi
done

if [[ ${found} == true ]]; then
    echo 0
else
    echo 1
fi
