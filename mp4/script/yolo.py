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
results = model.predict(src, imgsz=320, conf=0.5, classes=0, device='cpu', project='/mnt', name='detect', save=True)

# define
detection_info = []
current_person = None
counter = 0
total_frames = len(results)
duration = total_frames / fps

for index, r in enumerate(results):
    current_frame = index + 1
    # Check if someone exist
    if r.boxes.cls.size(0) > 0:
        if current_person is None:
            start_sec = current_frame / fps
            current_person = f"detect{counter + 1}"
            print(current_person)
            print(f"start_sec: {start_sec}")

            detection_info.append({
                "id": current_person,
                "start_sec": start_sec,
                "end_sec": None,
                "duration": duration
            })

        # Check if it's the last frame
        else:
            if current_frame == total_frames:
                end_sec = current_frame / fps
                print(f"end_sec: {end_sec}")
                detection_info[-1]["end_sec"] = end_sec

    # Check if someone doesn't exist
    else:
        if current_person is not None:
            end_sec = (current_frame - 1) / fps
            print(f"end_sec: {end_sec}")
            detection_info[-1]["end_sec"] = end_sec
            current_person = None
            counter += 1

json_output = json.dumps(detection_info, indent=2)
f = open(json_file, "w")
f.write(json_output)
f.close()

