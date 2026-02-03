from PIL import Image, ImageFilter, ImageChops
import numpy as np

# Load original logo
img = Image.open('data/logo.png')
print(f'Original size: {img.size}')

# Extract alpha channel
alpha = img.split()[3]

# Create a black outline by dilating the alpha channel
outline_width = 3  # pixels

# Dilate the alpha channel to create outline
outline = alpha.copy()
for i in range(outline_width):
    outline = outline.filter(ImageFilter.MaxFilter(3))

# Create black outline layer
outline_img = Image.new('RGBA', img.size, (0, 0, 0, 0))
outline_img.putalpha(outline)

# Subtract original alpha from outline to get just the border
outline_alpha = ImageChops.subtract(outline, alpha)
outline_img = Image.new('RGBA', img.size, (0, 0, 0, 255))
outline_img.putalpha(outline_alpha)

# Composite: outline first, then original logo on top
result = Image.new('RGBA', img.size, (0, 0, 0, 0))
result = Image.alpha_composite(result, outline_img)
result = Image.alpha_composite(result, img)

result.save('data/logo_contrast_fixed.png')
print('Saved logo with black outline to data/logo_contrast_fixed.png')

# Test on white background
white_bg = Image.new('RGB', result.size, (255, 255, 255))
white_bg.paste(result, (0, 0), result)
white_bg.save('data/logo_contrast_fixed_on_white.png')
print('Saved preview on white background')

# Verify contrast
test = np.array(white_bg)

def calc_luminance(r, g, b):
    r, g, b = r/255.0, g/255.0, b/255.0
    r = r/12.92 if r <= 0.03928 else ((r + 0.055)/1.055)**2.4
    g = g/12.92 if g <= 0.03928 else ((g + 0.055)/1.055)**2.4
    b = b/12.92 if b <= 0.03928 else ((b + 0.055)/1.055)**2.4
    return 0.2126*r + 0.7152*g + 0.0722*b

# Get non-white pixels
mask = ~((test[:,:,0]==255) & (test[:,:,1]==255) & (test[:,:,2]==255))
logo_px = test[mask]

if len(logo_px) > 0:
    lums = [calc_luminance(p[0], p[1], p[2]) for p in logo_px]
    min_lum, max_lum = min(lums), max(lums)
    min_contrast = 1.05 / (max_lum + 0.05)
    max_contrast = 1.05 / (min_lum + 0.05)
    
    print(f'\nContrast analysis:')
    print(f'  Luminance range: {min_lum:.3f} to {max_lum:.3f}')
    print(f'  Contrast range: {min_contrast:.2f}:1 to {max_contrast:.2f}:1')
    print(f'  Meets 3:1 minimum: {min_contrast >= 3.0}')
    
    # Check black outline pixels
    black_pixels = logo_px[(logo_px[:,0] < 50) & (logo_px[:,1] < 50) & (logo_px[:,2] < 50)]
    print(f'  Black outline pixels: {len(black_pixels)}')
    if len(black_pixels) > 0:
        black_lum = calc_luminance(black_pixels[0,0], black_pixels[0,1], black_pixels[0,2])
        black_contrast = 1.05 / (black_lum + 0.05)
        print(f'  Black outline contrast: {black_contrast:.2f}:1')
