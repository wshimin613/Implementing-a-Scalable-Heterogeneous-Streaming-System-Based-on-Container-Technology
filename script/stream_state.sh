#!/bin/bash

running_container=($( mysql -u root -pdic2727175 -D stream -e "select container_ip from camera where action='running';" -B -N ))

stop_container() {
    local ip=${1}
    local container_name=${2}
    ssh -o ConnectTimeout=1 "root@${ip}" "podman stop ${container_name}"
}

for i in ${running_container[@]}
do
    stream_state=$( podman ps | grep "stream_${i}" &> /dev/null ); state=${?}
    if [[ ${state} -eq 0 ]];then
        echo "running"
    else
        mysql -u root -pdic2727175 -D stream -e "UPDATE camera SET action='disconnect' WHERE container_ip='${i}';"
        echo "disconnect"
        container_name="nginx-rtmp_${i}"
	if podman ps | grep -q "${container_name}"; then
            echo 'exist localhost'
            podman stop "${container_name}"
        elif ssh -o ConnectTimeout=1 root@192.168.1.253 podman ps | grep -q "${container_name}"; then
    	    echo 'exist app1'
    	    stop_container "192.168.1.253" "${container_name}"
	elif ssh -o ConnectTimeout=1 root@192.168.1.252 podman ps | grep -q "${container_name}"; then
            echo 'exist app2'
    	    stop_container "192.168.1.252" "${container_name}"
	else
    	    echo 'not exist'
	fi
    fi
done

