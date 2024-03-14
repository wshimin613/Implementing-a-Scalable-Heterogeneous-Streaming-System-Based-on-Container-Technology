#!/bin/bash

# about hostname     ( for main.sh )
local_ip="192.168.1.254"
node1_ip="192.168.1.253"
node2_ip="192.168.1.252"

# about podman param ( for main.sh & detect.sh )
network="enp4s0"
mount_path="/home/stream/mp4/" # detect.sh
nginx_path="/home/stream/conf/nginx.conf"

# about detect param
year="2024"
record_path="/home/stream/mp4/record/${year}"
detect_path="/home/stream/mp4/detect/${year}"
