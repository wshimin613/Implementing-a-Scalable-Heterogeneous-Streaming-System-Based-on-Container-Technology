#!/bin/bash

#. /home/stream/script/functions.sh

disconnect_container=($( mysql -u root -pdic2727175 -D stream -e "select container_ip from camera where action='disconnect';" -B -N ))

for i in ${disconnect_container[@]}
do
	stream_name=$( mysql -u root -pdic2727175 -D stream -e "select stream_name from camera where container_ip='${i}';" -B -N )
	stream_ip=$( mysql -u root -pdic2727175 -D stream -e "select ip from camera where container_ip='${i}';" -B -N )
	sh /home/stream/script/main.sh ${stream_name} ${stream_ip} ${i}
	#IPcam=$( IPcam '1-5,7-11' ${stream_name} ${stream_ip} ${i} )
	#echo "${IPcam}"
done
