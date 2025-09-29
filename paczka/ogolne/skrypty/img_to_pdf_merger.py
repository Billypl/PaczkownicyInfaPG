import os
from PIL import Image


# Set your directory path here
image_dir = '.'
output_pdf = 'output.pdf'

# Supported image extensions
valid_exts = ('.jpg', '.jpeg', '.png', '.bmp', '.tiff')

# Get image files
images = [f for f in os.listdir(image_dir) if f.lower().endswith(valid_exts)]
images.sort()  # Optional: sort by name

# Convert to full path and open images
image_paths = [os.path.join(image_dir, img) for img in images]
image_list = []

for path in image_paths:
    img = Image.open(path).convert('RGB')  # Convert all to RGB
    image_list.append(img)

# Save as single PDF
if image_list:
    image_list[0].save(output_pdf, save_all=True, append_images=image_list[1:])
    print(f"PDF saved as {output_pdf}")
else:
    print("No images found in the directory.")
