from ultralytics import YOLO
import cv2
import os
import sys
import json

# Define file_path and filename
src = sys.argv[1]
filename_with_extension = os.path.basename(src)
filename, _ = os.path.splitext(filename_with_extension)
json_file = os.path.join("/mnt/detect/2024/json", f"{filename}.json")

# Load a pretrained YOLOv8n model
model = YOLO('yolov8n.pt')

# Get video fps
cap = cv2.VideoCapture(src)
fps = cap.get(cv2.CAP_PROP_FPS)
cap.release()

# Execute predict
results = model.predict(src, imgsz=320, conf=0.3, classes=56, device='cpu', project='/mnt', name='detect', save=True)

# index starts from 1
result_list = []
count = 0
for index, r in enumerate(results):
    if r.boxes.cls.size(0) > 0:
        frame = index + 1
        sec = frame / fps

        count += 1
        result = {
            f"detect{count}": sec
        }
        result_list.append(result)

json_output = json.dumps(result_list, indent=2)
f = open(json_file, "w")
f.write(json_output)
f.close()

