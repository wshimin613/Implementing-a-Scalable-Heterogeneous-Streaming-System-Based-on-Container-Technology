#!/bin/bash

date=${1}
result=$( find /home/stream/mp4/detect -type f -name "*${date}*.mp4" | xargs -I {} basename {} | sed 's/.*/"&"/' | jq -s '.' )
echo ${result}
