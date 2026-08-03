import os
import glob
from PIL import Image

def process_images(src_dir, dest_dir):
    for root, dirs, files in os.walk(src_dir):
        # Determine the relative path to replicate the directory structure
        rel_path = os.path.relpath(root, src_dir)
        dest_root = os.path.join(dest_dir, rel_path)

        if not os.path.exists(dest_root):
            os.makedirs(dest_root, exist_ok=True)

        for file in files:
            if file.lower().endswith(('.png', '.jpg', '.jpeg')):
                src_file = os.path.join(root, file)
                
                # Naming should be same, just change extension to webp
                base_name, _ = os.path.splitext(file)
                dest_file = os.path.join(dest_root, f"{base_name}.webp")

                try:
                    with Image.open(src_file) as img:
                        # Convert to RGB if it has alpha channel and we're saving to format that might not support it, 
                        # though webp supports alpha. But let's just save it.
                        # Resize for smartphone if very large (e.g., max width 1080)
                        # We'll just do quality reduction and webp format for now.
                        img.save(dest_file, "webp", quality=60, method=4)
                    print(f"Processed: {file} -> {base_name}.webp")
                except Exception as e:
                    print(f"Error processing {file}: {e}")

if __name__ == "__main__":
    src = "High Quality Files"
    dest = "Low Quality Files"
    process_images(src, dest)
