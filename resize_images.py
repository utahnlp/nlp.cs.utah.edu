import os
from PIL import Image

IMAGE_DIRECTORY = './assets/images/carousel'
EXTENSIONS = ('.jpg', '.jpeg', '.png')
MAX_WIDTH = 1500 
QUALITY = 80 

def resize_images():
    for file_name in os.listdir(IMAGE_DIRECTORY):
        if file_name.lower().endswith(EXTENSIONS):
            file_path = os.path.join(IMAGE_DIRECTORY, file_name)
            try:
                with Image.open(file_path) as image:
                    width_percent = (MAX_WIDTH / float(image.size[0]))
                    if width_percent < 1:
                        height = int((float(image.size[1]) * float(width_percent)))
                        image = image.resize((MAX_WIDTH, height), Image.Resampling.LANCZOS)
                        if image.mode in ("RGBA", "P"): 
                            image = image.convert("RGB")
                        image.save(file_path, "JPEG", optimize=True, quality=QUALITY)
                        print(f"Optimized: {file_name} -> {MAX_WIDTH}x{height}")
                    else:
                        print(f"Skipped (already small): {file_name}")
            except Exception as e:
                print(f"Error processing {file_name}: {e}")

if __name__ == "__main__":
    if os.path.exists(IMAGE_DIRECTORY):
        resize_images()
    else:
        print(f"Image directory not found: {IMAGE_DIRECTORY}")