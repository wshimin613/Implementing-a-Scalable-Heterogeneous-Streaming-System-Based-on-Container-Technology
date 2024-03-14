#!/bin/bash

container_ip=${1}
container_name="nginx-rtmp_${container_ip}"
mysql -u root -pdic2727175 -D stream -e "UPDATE camera SET action='idle' WHERE container_ip='${container_ip}';"

stop_container() {
    local ip=${1}
    ssh -o ConnectTimeout=1 "root@${ip}" "podman stop ${container_name}"
}

if podman ps | grep -q "${container_name}"; then
    echo 'exist localhost'
    podman stop "${container_name}"
elif ssh -o ConnectTimeout=1 root@192.168.1.253 podman ps | grep -q "${container_name}"; then
    echo 'exist app1'
    stop_container "192.168.1.253"
elif ssh -o ConnectTimeout=1 root@192.168.1.252 podman ps | grep -q "${container_name}"; then
    echo 'exist app2'
    stop_container "192.168.1.252"
else
    echo 'not exist'
fi
