#!/bin/bash

running_container=($( mysql -u root -pdic2727175 -D stream -e "select container_ip from camera where action='running';" -B -N ))

for i in ${running_container[@]}
do
	stream_state=$( podman ps | grep "stream_${i}" &> /dev/null ); state=${?}
	if [[ ${state} -eq 0 ]];then
		#echo "stream_${i}: running"
		echo "running"
	else
		mysql -u root -pdic2727175 -D stream -e "UPDATE camera SET action='disconnect' WHERE container_ip='${i}';"
		#echo "stream_${i}: disconnect"
		echo "disconnect"
	fi
done
