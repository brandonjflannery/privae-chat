# PrivaeChat Branding Automation

## Overview

PrivaeChat uses a single source logo (`privae-logo-1.png`) to automatically generate all required branding assets including favicons for different platforms and sizes.

---

## Source Logo

**Location:** `config/branding/privae-logo-1.png`

**Specifications:**
- Format: PNG
- Size: 1024×1024 pixels
- Background: Transparent
- Design: Privacy-themed "hat and glasses" icon

**This is your SINGLE SOURCE OF TRUTH** for all branding. All other assets are generated from this file.

---

## Automated Branding Script

### Script: `scripts/apply-branding.sh`

This enhanced script automatically:
1. Checks if ImageMagick is installed
2. Generates all favicon sizes from `privae-logo-1.png`
3. Copies main logo to LibreChat
4. Copies all favicons to LibreChat
5. Applies custom HTML/CSS (if present)

### Usage

```bash
# Apply branding (generates favicons if ImageMagick is installed)
cd /home/mbc/dev/privae-chat
./scripts/apply-branding.sh
```

---

## Favicon Generation

### Required Tool: ImageMagick

The script uses ImageMagick's `convert` command to generate favicons.

**Installation:**
```bash
# Option 1: Manual installation
sudo apt-get update && sudo apt-get install -y imagemagick

# Option 2: Use helper script
cd /home/mbc/dev/privae-chat
./scripts/install-imagemagick.sh
```

**Verify installation:**
```bash
which convert
convert --version
```

### Generated Favicon Sizes

When ImageMagick is available, the script generates these files:

| File | Size | Purpose | Background |
|------|------|---------|------------|
| `favicon-16x16.png` | 16×16 | Browser tab (small) | Transparent |
| `favicon-32x32.png` | 32×32 | Browser tab (standard) | Transparent |
| `apple-touch-icon-180x180.png` | 180×180 | iOS home screen | **White** (required by Apple) |
| `icon-192x192.png` | 192×192 | Android/PWA | Transparent |
| `icon-512x512.png` | 512×512 | Android/PWA (hi-res) | Transparent |
| `maskable-icon.png` | 512×512 | Android adaptive icon | **White** + 10% padding |

**Note:** iOS and Android maskable icons use white backgrounds for better visibility on dark home screens.

### Storage Locations

**Generated favicons saved to:**
- `config/branding/favicons/` (version controlled)

**Copied to LibreChat:**
- `librechat/client/public/assets/` (not version controlled)

---

## Complete Workflow

### 1. Update Logo

Replace the source logo:
```bash
# Copy your new logo to the branding directory
cp /path/to/your/new-logo.png config/branding/privae-logo-1.png
```

### 2. Install ImageMagick (First Time Only)

```bash
./scripts/install-imagemagick.sh
```

### 3. Generate and Apply Branding

```bash
./scripts/apply-branding.sh
```

### 4. Rebuild Frontend (If Needed)

If you've pre-built the frontend, you may need to rebuild:
```bash
cd librechat
npm run frontend:ci
```

**Note:** If using the pre-built frontend from backup, rebuilding is NOT necessary - the assets are in `client/public/assets/` which is already deployed.

### 5. Restart LibreChat

```bash
./scripts/stop-services.sh
./scripts/start-services.sh --tunnel
```

---

## File Structure

```
config/branding/
├── privae-logo-1.png              ← SOURCE LOGO (1024×1024)
├── favicons/                       ← Auto-generated favicons
│   ├── favicon-16x16.png          (browser tab)
│   ├── favicon-32x32.png          (browser tab)
│   ├── apple-touch-icon-180x180.png (iOS, white bg)
│   ├── icon-192x192.png           (Android/PWA)
│   ├── icon-512x512.png           (Android/PWA hi-res)
│   └── maskable-icon.png          (Android adaptive, white bg)
├── logo.svg                        ← Legacy SVG (optional)
├── index.html                      ← Custom HTML metadata (optional)
└── style.css                       ← Custom CSS (optional)

librechat/client/public/assets/     ← Where branding is applied
├── logo.png                        (copy of privae-logo-1.png)
├── logo.svg                        (copy if present)
└── favicon-*.png                   (all favicons)
```

---

## Without ImageMagick

If ImageMagick is not installed, the script will:
- ✅ Copy the main logo (`privae-logo-1.png` → `logo.png`)
- ✅ Copy any existing favicons from `config/branding/favicons/`
- ⚠️  **Not** generate new favicons from the source logo
- ⚠️  Display installation instructions

**In this case:** You'll need to manually create favicon files and place them in `config/branding/favicons/`, or install ImageMagick.

---

## Testing Branding

After applying branding, verify it appears correctly:

### Browser
1. Open http://localhost:3026
2. Check browser tab shows correct favicon
3. Check login page shows correct logo

### iOS (PWA)
1. Open in Safari
2. Tap Share → Add to Home Screen
3. Check icon on home screen

### Android (PWA)
1. Open in Chrome
2. Tap Menu → Add to Home Screen
3. Check icon on home screen

---

## Troubleshooting

### Favicons Not Updating

**Problem:** Browser cache is showing old favicons

**Solution:**
```bash
# Clear browser cache (Ctrl+Shift+Delete)
# Or force refresh: Ctrl+Shift+R (Linux/Windows) or Cmd+Shift+R (Mac)
```

### ImageMagick Not Found

**Problem:** Script reports ImageMagick is not installed

**Solution:**
```bash
# Install ImageMagick
./scripts/install-imagemagick.sh

# Then re-run branding script
./scripts/apply-branding.sh
```

### Logo Not Appearing

**Problem:** Logo doesn't show on login page

**Solution:**
```bash
# Verify logo was copied
ls -lh librechat/client/public/assets/logo.png

# If missing, re-run script
./scripts/apply-branding.sh

# Check LibreChat logs
tail -f logs/librechat-backend.log
```

### Old Favicons Still Present

**Problem:** Old favicons from previous logo still showing

**Solution:**
```bash
# Delete old favicons
rm -rf config/branding/favicons/*.png

# Regenerate from new logo
./scripts/apply-branding.sh

# Clear browser cache
```

---

## Manual Favicon Generation

If you prefer to generate favicons manually (without the script):

```bash
cd config/branding

# Browser favicons
convert privae-logo-1.png -resize 16x16 -background none -flatten favicons/favicon-16x16.png
convert privae-logo-1.png -resize 32x32 -background none -flatten favicons/favicon-32x32.png

# iOS icon
convert privae-logo-1.png -resize 180x180 -background white -flatten favicons/apple-touch-icon-180x180.png

# Android icons
convert privae-logo-1.png -resize 192x192 -background none -flatten favicons/icon-192x192.png
convert privae-logo-1.png -resize 512x512 -background none -flatten favicons/icon-512x512.png

# Maskable icon
convert privae-logo-1.png -resize 410x410 -background white -gravity center -extent 512x512 favicons/maskable-icon.png
```

---

## Best Practices

### Logo Design
- ✅ Use simple, recognizable designs
- ✅ Ensure logo works at small sizes (16×16)
- ✅ Test on both light and dark backgrounds
- ✅ Use high contrast colors
- ✅ Avoid fine details that don't scale well

### File Management
- ✅ Keep `privae-logo-1.png` as your source of truth
- ✅ Version control the source logo in git
- ✅ Version control generated favicons in git
- ✅ Don't manually edit generated favicons (they'll be overwritten)

### Updates
- ✅ When changing the logo, regenerate ALL favicons
- ✅ Test on multiple devices/browsers
- ✅ Clear caches after updating

---

## Quick Reference

```bash
# Change logo
cp new-logo.png config/branding/privae-logo-1.png

# Apply branding
./scripts/apply-branding.sh

# Restart services
./scripts/stop-services.sh
./scripts/start-services.sh --tunnel

# Verify
# Open http://localhost:3026
```

---

## Related Documentation

- `docs/BRANDING_PLAN.md` - Complete branding customization guide
- `docs/BRANDING_VISUAL_GUIDE.md` - Visual reference with diagrams
- `docs/QUICK_START.md` - Getting started with PrivaeChat
- `scripts/apply-branding.sh` - Branding automation script
- `scripts/install-imagemagick.sh` - ImageMagick installation helper

---

**Last Updated:** 2025-10-18
