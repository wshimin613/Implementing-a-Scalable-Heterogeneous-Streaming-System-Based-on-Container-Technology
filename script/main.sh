#!/bin/bash

. /home/stream/script/config.sh
. /home/stream/script/functions.sh

stream_name=${1}
stream_ip=${2}
container_ip=${3}

ping -c 1 ${local_ip} &> /dev/null; LB_status=$?
ping -c 1 ${node1_ip} &> /dev/null; app1_status=$?
ping -c 1 ${node2_ip} &> /dev/null; app2_status=$?

if [[ ${LB_status} -eq 0 && ${app1_status} -eq 0 && ${app2_status} -eq 0 ]];then
	balance=$( load_balance )
	echo "Selected Server IP: ${balance}"
	cpuset=$( cpuset ${balance} )
	echo "Selected thread: ${cpuset}"
	rtmp=$( rtmp ${container_ip} ${balance} ${cpuset} )

	if [[ ${rtmp} == 'success' ]];then
        	IPcam=$( IPcam ${cpuset} ${stream_name} ${stream_ip} ${container_ip} )
        	echo ${IPcam}
	else
		echo ${rtmp}
        fi

elif [[ ${LB_status} != 0 ]];then
	echo 'Load balance server unable to connect or not powered on'
elif [[ ${app1_status} != 0 ]];then
	echo 'Application server 1 unable to connect or not powered on'
else
	echo 'Application server 2 unable to connect or not powered on'
fi
