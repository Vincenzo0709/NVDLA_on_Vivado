# Example input for ResNet50: 3 channels, 224x224 image

import cv2
import sys
import os

# Constants
size = [224, 224]

# Current path
dir = os.path.dirname(os.path.abspath(__file__))

# Image path
img_path = os.path.join(dir, "../ResNet50/images/000.jpg")

# Open the image
img = cv2.imread(img_path)
if img is None:
    print("ERROR!: Image not found or failed to load.")
    sys.exit(1)

# Convert BGR to RGB color space
img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

# Resize width/height to 224x224
w, h = img.shape[:2]
target_w, target_h = size
scale_w = target_w / w
scale_h = target_h / h
new_w = int(w * scale_w)
new_h = int(h * scale_h)

print("Resizing\n\tWidth: from {} to {},\n\tHeight: from {} to {}\n".format(w, new_w, h, new_h))

resized_img = cv2.resize(img, (new_w, new_h), interpolation=cv2.INTER_AREA)

# Saving to jpg
img_bgr = cv2.cvtColor(resized_img, cv2.COLOR_RGB2BGR)
cv2.imwrite("out.jpg", img_bgr)
