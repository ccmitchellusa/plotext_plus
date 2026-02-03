from PIL import Image
import numpy as np

# Load original logo
img = Image.open('data/logo.png')
pixels = np.array(img, dtype=float)
rgb = pixels[:,:,:3]
alpha = pixels[:,:,3]

# Calculate luminance (WCAG formula)
def calc_luminance(r, g, b):
    # Normalize to 0-1
    r, g, b = r/255.0, g/255.0, b/255.0
    # Apply gamma correction
    r = r/12.92 if r <= 0.03928 else ((r + 0.055)/1.055)**2.4
    g = g/12.92 if g <= 0.03928 else ((g + 0.055)/1.055)**2.4
    b = b/12.92 if b <= 0.03928 else ((b + 0.055)/1.055)**2.4
    return 0.2126*r + 0.7152*g + 0.0722*b

# Target: 3:1 contrast against white (luminance=1.0)
# Max luminance: (1.05 / 3.0) - 0.05 = 0.3
max_lum = 0.3

modified = rgb.copy()
changes = 0

for i in range(pixels.shape[0]):
    for j in range(pixels.shape[1]):
        if alpha[i,j] > 0:
            r, g, b = rgb[i,j]
            lum = calc_luminance(r, g, b)
            
            if lum > max_lum:
                # Darken by scaling RGB values
                scale = max_lum / lum
                modified[i,j] = rgb[i,j] * scale
                changes += 1

print(f'Darkened {changes} pixels to meet 3:1 contrast')

# Create result image
result = np.zeros_like(pixels)
result[:,:,:3] = np.clip(modified, 0, 255)
result[:,:,3] = alpha
result_img = Image.fromarray(result.astype(np.uint8), 'RGBA')
result_img.save('data/logo_contrast_fixed.png')

# Verify
white_bg = Image.new('RGB', result_img.size, (255, 255, 255))
white_bg.paste(result_img, (0, 0), result_img)
test = np.array(white_bg)

# Get logo pixels (non-white)
mask = ~((test[:,:,0]==255) & (test[:,:,1]==255) & (test[:,:,2]==255))
logo_px = test[mask]

lums = [calc_luminance(p[0], p[1], p[2]) for p in logo_px]
min_lum, max_lum_actual = min(lums), max(lums)
min_contrast = 1.05 / (max_lum_actual + 0.05)
max_contrast = 1.05 / (min_lum + 0.05)

print(f'\nVerification:')
print(f'  Luminance range: {min_lum:.3f} to {max_lum_actual:.3f}')
print(f'  Contrast range: {min_contrast:.2f}:1 to {max_contrast:.2f}:1')
print(f'  Meets 3:1 minimum: {min_contrast >= 3.0}')
