#!/bin/bash

function load_balance(){
    local LB_max=$(( $(nproc) - 2 ))
    local LB_avl=$(( ${LB_max} - $(podman ps | grep nginx | wc -l) ))
    local app1_max=$(( $(ssh -o ConnectTimeout=1 root@${node1_ip} 'nproc') - 2 ))
    local app1_avl=$(( ${app1_max} - $(ssh -o ConnectTimeout=1 root@${node1_ip} 'podman ps | grep nginx | wc -l') ))
    local app2_max=$(( $(ssh -o ConnectTimeout=1 root@${node2_ip} 'nproc') - 2 ))
    local app2_avl=$(( ${app1_max} - $(ssh -o ConnectTimeout=1 root@${node2_ip} 'podman ps | grep nginx | wc -l') ))
    local LB_ratio=$( printf "%.2f" "$(echo "scale=2; ${LB_avl} / ${LB_max}" | bc)" )
    local app1_ratio=$( printf "%.2f" "$(echo "scale=2; ${app1_avl} / ${app1_max}" | bc)" )
    local app2_ratio=$( printf "%.2f" "$(echo "scale=2; ${app2_avl} / ${app2_max}" | bc)" )
    
    if (( $(echo "${LB_ratio} >= ${app1_ratio}" | bc -l) )) && (( $(echo "${LB_ratio} >= ${app2_ratio}" | bc -l) ));then
        if (( $(echo "${LB_ratio} == 0" | bc -l) )) && (( $(echo "${app1_ratio} == 0" | bc -l) )) && (( $(echo "${app2_ratio} == 0" | bc -l) ));then
    	    echo 'No machine available'
    	else
    	    echo ${local_ip}
    	fi
    elif (( $(echo "${app1_ratio} > ${LB_ratio}" | bc -l) )) && (( $(echo "${app1_ratio} >= ${app2_ratio}" | bc -l) ));then
        echo ${node1_ip}
    else
        echo ${node2_ip}
    fi
}

function cpuset(){
    local balance=${1}
    
    case ${balance} in
    ${local_ip})
        num_cpus=$( nproc )
        ;;
    ${node1_ip} | ${node2_ip})
        num_cpus=$( ssh -o ConnectTimeout=1 root@${balance} 'nproc' )
        ;;
    *)
        echo 'The function cpuset include error value'
        ;;
    esac
    
    if [[ -n ${num_cpus} ]];then
        cpu_1st=$(( num_cpus / 2 - 1 ))
        cpu_2nd=$(( num_cpus / 2 + 1 ))
        cpu_3rd=$(( num_cpus - 1 ))
        echo "1-${cpu_1st},${cpu_2nd}-${cpu_3rd}"
    fi
}

function rtmp(){
    local container_ip=${1}
    local balance=${2}
    local cpuset=${3}

    ping -c 1 -w 1 192.168.3.${container_ip} &> /dev/null; state=$?

    if [[ ${state} -ne 0 ]];then
        case ${balance} in
    	${local_ip} | ${node1_ip} | ${node2_ip})
    	    local container_name="nginx-rtmp_${container_ip}"
    	    local remote_cmd=""
    		
    	    if [[ ${balance} != ${local_ip} ]];then
    	        remote_cmd="ssh -o ConnectTimeout=1 root@${balance}"
    	    fi
    
    	    ${remote_cmd} podman run -d --rm --name ${container_name} --cpuset-cpus ${cpuset} --network ${network} \
    	    --ip=192.168.3.${container_ip} -e TZ=Asia/Taipei -v ${mount_path}:/mp4 nginx-rtmp_inst:latest &> /dev/null; build_status=$?
    		
    	    if [[ ${build_status} -eq 0 ]];then
    	        ${remote_cmd} podman cp ${nginx_path} ${container_name}:/etc/nginx/nginx.conf
    		${remote_cmd} podman exec -it ${container_name} nginx -s reload &> /dev/null
    		arping -q -c 1 -w 1 -I mynet 192.168.3.${container_ip} # update ARP cache
    		ping -c 1 -w 1 192.168.3.${container_ip} &> /dev/null; ping=$?

    		if [[ ${ping} -eq 0 ]];then
    		    echo 'success'
                else
    	            echo 'ping error'
    	        fi
    	    else
    	        echo 'Container created failed'
    	    fi
    	    ;;
    	*)
    	    echo 'The function rtmp include error value'
    	    ;;
    	esac
    else
        echo "container ip ${container_ip} is exist"
    fi
}

function IPcam(){
    local cpuset=${1}
    local stream_name=${2}
    local stream_ip=${3}
    local container_ip=${4}
    #local network='enp4s0'

    stream_URL=(
        "rtsp://admin:Dic2727175@${stream_ip}:554/1/h264major"
        "rtsp://admin:Dic2727175@${stream_ip}:554/stream0"
        "rtsp://admin:Dic2727175@${stream_ip}:554/live/ch00_1"
    )
    
    for url in "${stream_URL[@]}"
    do
        encoder=$( ffprobe -rtsp_transport tcp -show_streams -i ${url} -v quiet | grep -Po 'codec_name=\K\w+' ); state=$?
    	if [[ ${state} -eq 0 ]]; then
    	    break
    	fi
    done
    
    podman_cmd="podman run -d --rm --name stream_${container_ip} --cpuset-cpus ${cpuset} --network ${network} --ip=192.168.2.${container_ip} linuxserver/ffmpeg:latest -rtsp_transport tcp -i ${url}"
    #ffmpeg_options="-crf 18 -preset ultrafast -tune zerolatency -stats -loglevel warning -hide_banner"
    ffmpeg_options="-crf 18 -preset ultrafast -tune zerolatency"
    if [[ -n ${encoder} && ${encoder} == 'h264' ]];then
        ${podman_cmd} -c:v copy -an ${ffmpeg_options} -f flv rtmp://192.168.3.${container_ip}:1935/live/${stream_name} &> /dev/null
        mysql -u root -pdic2727175 -D stream -e "UPDATE camera SET stream_name='${stream_name}', action='running' WHERE container_ip='${container_ip}';"
        echo "success"
    elif [[ -z ${encoder} ]];then
        echo 'function IPcam error'
    else
        ${podman_cmd} -c:v libx264 -an ${ffmpeg_options} -f flv rtmp://192.168.3.${container_ip}:1935/live/${stream_name} &> /dev/null
    	mysql -u root -pdic2727175 -D stream -e "UPDATE camera SET stream_name='${stream_name}', action='running' WHERE container_ip='${container_ip}';"
        echo "success"
    fi
}
