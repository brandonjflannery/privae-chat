#!/usr/bin/env python3
"""
Generate all favicon sizes from source logo using PIL/Pillow
Alternative to ImageMagick for favicon generation
"""

import sys
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    print("❌ Pillow (PIL) not installed. Install with:")
    print("   pip3 install Pillow")
    sys.exit(1)

# Paths
SCRIPT_DIR = Path(__file__).parent
PROJECT_ROOT = SCRIPT_DIR.parent
SOURCE_LOGO = PROJECT_ROOT / "config/branding/privae-logo-1.png"
FAVICON_DIR = PROJECT_ROOT / "config/branding/favicons"

# Ensure favicon directory exists
FAVICON_DIR.mkdir(parents=True, exist_ok=True)

# Check if source logo exists
if not SOURCE_LOGO.exists():
    print(f"❌ Source logo not found at: {SOURCE_LOGO}")
    sys.exit(1)

print(f"🖼️  Generating favicons from {SOURCE_LOGO.name}...")
print()

# Load source image
source_img = Image.open(SOURCE_LOGO)

# Favicon configurations: (filename, size, background_color)
# background_color: None = transparent, 'white' = white background
favicons = [
    ("favicon-16x16.png", 16, None),
    ("favicon-32x32.png", 32, None),
    ("apple-touch-icon-180x180.png", 180, "white"),  # iOS requires opaque
    ("icon-192x192.png", 192, None),
    ("icon-512x512.png", 512, None),
]

# Generate each favicon
for filename, size, bg_color in favicons:
    output_path = FAVICON_DIR / filename

    # Create a copy and resize
    favicon = source_img.copy()
    favicon = favicon.resize((size, size), Image.Resampling.LANCZOS)

    # Apply background if needed
    if bg_color:
        # Create new image with background
        if bg_color == "white":
            bg = Image.new("RGB", (size, size), (255, 255, 255))
        else:
            bg = Image.new("RGB", (size, size), bg_color)

        # Paste favicon on background (handles transparency)
        if favicon.mode == "RGBA":
            bg.paste(favicon, (0, 0), favicon)
        else:
            bg.paste(favicon, (0, 0))

        favicon = bg

    # Save
    if favicon.mode == "RGBA" and bg_color is None:
        favicon.save(output_path, "PNG", optimize=True)
    else:
        favicon.save(output_path, "PNG", optimize=True)

    bg_note = f" (white bg)" if bg_color == "white" else ""
    print(f"  ✓ Generated {filename}{bg_note}")

# Generate maskable icon (with padding)
print()
print("🎭 Generating maskable icon with padding...")

# Maskable icon needs padding (safe zone)
maskable_size = 512
padding_percent = 10
inner_size = int(maskable_size * (100 - 2 * padding_percent) / 100)

# Create white background
maskable = Image.new("RGB", (maskable_size, maskable_size), (255, 255, 255))

# Resize logo to fit with padding
logo_resized = source_img.copy()
logo_resized = logo_resized.resize((inner_size, inner_size), Image.Resampling.LANCZOS)

# Calculate position to center
offset = (maskable_size - inner_size) // 2

# Paste logo in center (handles transparency)
if logo_resized.mode == "RGBA":
    maskable.paste(logo_resized, (offset, offset), logo_resized)
else:
    maskable.paste(logo_resized, (offset, offset))

maskable.save(FAVICON_DIR / "maskable-icon.png", "PNG", optimize=True)
print(f"  ✓ Generated maskable-icon.png (white bg + {padding_percent}% padding)")

print()
print("✅ All favicons generated successfully!")
print()
print(f"📁 Saved to: {FAVICON_DIR}/")
