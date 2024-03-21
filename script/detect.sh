#!/bin/bash

. ./config.sh

# search file
record_array=($( find ${record_path} -type f -name '*.mp4' | xargs -I {} basename {} ))
detect_array=($( find ${detect_path} -type f -name '*.mp4' | xargs -I {} basename {} ))

array=() # diff set
for i in "${record_array[@]}"
do
    skip=
    for j in "${detect_array[@]}"
    do
        [[ $i == $j ]] && { skip=1; break; }
    done
    [[ -n $skip ]] || array+=("$i")
done

if [[ ${#array[@]} != 0 ]];then
    echo "要處理的影片: ${array[@]}"
    i=1 # flag
    for filename in ${array[@]}
    do
        path=$( podman run --rm -v ${mount_path}:/mnt yolov8:v1 find /mnt -name ${filename} )
        #podman run --rm --cpuset-cpus "1-5,7-11" --name yolov8 -v ${mount_path}:/mnt \
	#    yolov8:v1 python3 /mnt/script/yolo.py ${path} &> /dev/null; state=$?
        podman run --rm --cpuset-cpus "1-5,7-11" --name yolov8 -v ${mount_path}:/mnt \
	    yolov8:v1 python3 /mnt/script/yolo.py ${path} ; state=$?

        if [[ ${state} == 0 ]];then
            month=$( echo ${filename} | cut -d '-' -f 3 )

	    if [[ ! -d "${detect_path}/${month}" ]];then
	        mkdir -p ${detect_path}/${month}
	        echo "create ${detect_path}/${month}"
	    fi

            #podman run --rm --cpuset-cpus "1-5,7-11" --name ffmpeg -v ${mount_path}/detect:/config \
            #    ffmpeg:latest -i /config/${filename} -c:v libx264 -an -y /config/${year}/${month}/${filename}
            podman run --rm --device="/dev/dri/:/dev/dri/" --cpuset-cpus "1-5,7-11" --name ffmpeg -v ${mount_path}/detect:/config \
                ffmpeg:latest -i /config/${filename} -c:v h264_qsv -an -global_quality 23 -y /config/${year}/${month}/${filename}

            rm -f /home/stream/mp4/detect/${filename}
	    echo "---------------------------"
	    echo "Processing succeeded: ${path}"
	    echo "已完成的影片數量: ${i}"
	    echo "剩餘要處理的影片數量: $((${#array[@]} - ${i}))"
	    (( i++ ))
        else
            echo 'Predict failed'
        fi
    done
else
    echo '影片皆已處理完畢'
fi

