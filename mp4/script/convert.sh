#!/bin/bash

path=${1}
basename=${2}

ffmpeg -i ${path} -c:v copy -an "/mp4/record/${basename}.mp4" && rm -f ${path}

for file in /mp4/record/*.mp4
do
        year=$( date +%Y -r "${file}" )
        month=$( date +%m -r "${file}" )
	path="/mp4/record/${year}/${month}"

	if [ -d ${path} ];then
		echo 'exist'
        	mv ${file} ${path}
	else 
		echo 'not exist'
		mkdir -p ${path}
        	mv ${file} ${path}
	fi
done
