# Simple Streaming
---

關於負載平衡與影像辨識的集成

## Environment

* Operating System: Rocky Linux 9.2
* Cluster Architecture: Three computational servers and one storage server.


## Path

* `conf` Nginx.conf 設定檔，每個容器使用該檔案
* `mp4` yolov8 人形人形辨識腳本
* `script` 系統平台相關腳本
* `web` 提供基本的串流網頁（串流監控、IP camera 狀態、直播顯示、查詢歷史影片等）

## Tools

* podman
* ffmpeg
* ffprobe

