## 專案名稱
基於Container技術實現可擴充之異質性串流系統

## 專案介紹
串流服務在高峰期面臨服務中斷的挑戰。為提升穩定性，本研究使用異質性叢集系統和容器技術來模擬多個串流輸入，以測試和分析效能瓶頸。研究結果顯示， CPU 負載過高是主要瓶頸，而非記憶體、硬碟或網路頻寬等問題。

本研究推導出 CPU 核心數量與最佳串流數量的關聯，並建立了一套適用於異質環境的負載平衡演算法，比傳統方法更有效率。此外為了提高影片檢索效率，本研究利用YOLOv8物件偵測技術記錄物件出現的時間段，幫助使用者快速定位感興趣的內容。

## 目錄和檔案說明
- **conf：** 放置nginx.conf主設定檔，容器啟動時都會掛載該目錄。
- **mp4/script：** 主要放置YOLOv8物件偵測的Python腳本。
- **script：** 主要功能包括負載平衡、串流監控、IP camera狀態和與DataBase Server連接。
- **web：** 提供基本的串流管理介面（串流監控、管理IP camera、即時直播、查詢歷史影片等）。

> [!NOTE]
> 部份腳本可能因系統環境不同，若直接下載可能無法正常運行。

## 專案架構
採用水平擴充的方式建立叢集伺服器（Cluster Servers），並對其運作方法進行改進。將應用程式和服務打包並部署成容器運行，這樣有助於降低服務之間的耦合性，減少服務和模組之間的依賴程度，使系統能夠更準確的針對資源消耗較大的服務進行彈性擴充，從而實現微服務架構。

<img src="https://github.com/wshimin613/Implementing-a-Scalable-Heterogeneous-Streaming-System-Based-on-Container-Technology/assets/83169038/cb874402-1fca-446d-a7c7-4b5f3a828c52" alt="system" width="500"/>

## Demo

| 網路攝影機管理介面 | 串流監控介面 |
| --- | --- |
|![web_camera](https://github.com/wshimin613/Implementing-a-Scalable-Heterogeneous-Streaming-System-Based-on-Container-Technology/assets/83169038/0da74023-7acf-422b-a5d2-e862c6642dc1)|![web_monitor](https://github.com/wshimin613/Implementing-a-Scalable-Heterogeneous-Streaming-System-Based-on-Container-Technology/assets/83169038/968a6078-f20a-4c56-bc7b-1ed12e543578)|

| 直播介面 | 歷史影片查詢介面 (附帶時間軸標記和章節列表功能) |
| --- | --- |
|![web_live](https://github.com/wshimin613/Implementing-a-Scalable-Heterogeneous-Streaming-System-Based-on-Container-Technology/assets/83169038/ddfaaf15-36c1-4425-ad6c-0d07a2793269)|![test](https://github.com/wshimin613/Implementing-a-Scalable-Heterogeneous-Streaming-System-Based-on-Container-Technology/assets/83169038/62385576-b5a3-461d-80cd-786e3e13e52b)|

## Environment
* Operating System: Rocky Linux 9.2
* Cluster Architecture: Three Node servers and one storage server.

## Tools
* podman
* ffmpeg
* ffprobe
* YOLOv8
* iptables
* NFS
