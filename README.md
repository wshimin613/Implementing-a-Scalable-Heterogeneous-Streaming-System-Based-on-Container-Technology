## 專案名稱
基於異質性叢集架構中應用Container技術進行負載平衡之研究

## 專案介紹

## 目錄和檔案說明
- **conf：** 放置nginx.conf主設定檔，容器啟動時都會掛載該目錄。
- **mp4/script：** 主要放置YOLOv8物件偵測的Python腳本。
- **script：** 主要功能包括負載平衡、串流監控、IP camera狀態和與DataBase Server通訊。
- **web：** 提供基本的串流管理介面（串流監控、管理IP camera、即時直播、查詢歷史影片等）。

> [!NOTE]
> 部份腳本可能因系統環境不同，若直接下載可能無法正常運行。

## 專案架構

## Demo





## Environment

* Operating System: Rocky Linux 9.2
* Cluster Architecture: Three computational servers and one storage server.

## Tools

* podman
* ffmpeg
* ffprobe
