#!/bin/bash
# Applies branding assets from privae-chat/config/branding/ to librechat/
# Auto-generates all favicon sizes from source logo

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LIBRECHAT_DIR="$PROJECT_ROOT/librechat"
BRANDING_DIR="$PROJECT_ROOT/config/branding"
SOURCE_LOGO="$BRANDING_DIR/privae-logo-1.png"
FAVICON_DIR="$BRANDING_DIR/favicons"

# Check if LibreChat directory exists
if [ ! -d "$LIBRECHAT_DIR" ]; then
    echo "❌ LibreChat directory not found at $LIBRECHAT_DIR"
    exit 1
fi

echo "🎨 Applying PrivaeChat branding to LibreChat..."
echo ""

# Check and configure APP_TITLE in .env
echo "📝 Checking APP_TITLE configuration..."
if ! grep -q "^APP_TITLE=" "$PROJECT_ROOT/config/.env" 2>/dev/null; then
    echo "  ⚠️  APP_TITLE not found in config/.env"
    echo "  Adding APP_TITLE=Privae..."
    echo "" >> "$PROJECT_ROOT/config/.env"
    echo "#==================================" >> "$PROJECT_ROOT/config/.env"
    echo "# Branding Configuration" >> "$PROJECT_ROOT/config/.env"
    echo "#==================================" >> "$PROJECT_ROOT/config/.env"
    echo "APP_TITLE=Privae" >> "$PROJECT_ROOT/config/.env"
    echo "  ✓ Added APP_TITLE=Privae to config/.env"
else
    APP_TITLE_VALUE=$(grep "^APP_TITLE=" "$PROJECT_ROOT/config/.env" | cut -d'=' -f2)
    echo "  ✓ APP_TITLE already set to: $APP_TITLE_VALUE"
fi
echo ""

# Ensure LibreChat assets directory exists
mkdir -p "$LIBRECHAT_DIR/client/public/assets"
mkdir -p "$FAVICON_DIR"

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "⚠️  ImageMagick not found. Install it to auto-generate favicons:"
    echo "   sudo apt-get update && sudo apt-get install -y imagemagick"
    echo ""
    echo "Proceeding without favicon generation..."
    SKIP_FAVICON_GEN=true
else
    SKIP_FAVICON_GEN=false
fi

# Generate favicons from source logo if ImageMagick is available
if [ "$SKIP_FAVICON_GEN" = false ] && [ -f "$SOURCE_LOGO" ]; then
    echo "🖼️  Generating favicons from privae-logo-1.png..."

    # Small browser favicons (transparent background)
    convert "$SOURCE_LOGO" -resize 16x16 -background none -flatten "$FAVICON_DIR/favicon-16x16.png"
    echo "  ✓ Generated favicon-16x16.png"

    convert "$SOURCE_LOGO" -resize 32x32 -background none -flatten "$FAVICON_DIR/favicon-32x32.png"
    echo "  ✓ Generated favicon-32x32.png"

    # iOS icon (white background required by Apple)
    convert "$SOURCE_LOGO" -resize 180x180 -background white -flatten "$FAVICON_DIR/apple-touch-icon-180x180.png"
    echo "  ✓ Generated apple-touch-icon-180x180.png (white bg)"

    # Android/PWA icons (transparent)
    convert "$SOURCE_LOGO" -resize 192x192 -background none -flatten "$FAVICON_DIR/icon-192x192.png"
    echo "  ✓ Generated icon-192x192.png"

    convert "$SOURCE_LOGO" -resize 512x512 -background none -flatten "$FAVICON_DIR/icon-512x512.png"
    echo "  ✓ Generated icon-512x512.png"

    # Maskable icon (white background + 10% padding for safe zone)
    convert "$SOURCE_LOGO" -resize 410x410 -background white -gravity center -extent 512x512 "$FAVICON_DIR/maskable-icon.png"
    echo "  ✓ Generated maskable-icon.png (white bg + padding)"

    echo "✅ All favicons generated successfully!"
    echo ""
elif [ ! -f "$SOURCE_LOGO" ]; then
    echo "⚠️  Source logo not found at: $SOURCE_LOGO"
    echo "   Place your logo there to auto-generate favicons"
    echo ""
fi

# Copy main logo (PNG version for LibreChat)
if [ -f "$SOURCE_LOGO" ]; then
    echo "📋 Copying main logo..."
    cp "$SOURCE_LOGO" "$LIBRECHAT_DIR/client/public/assets/logo.png"
    echo "  ✓ Logo copied as logo.png"
else
    echo "⚠️  Main logo not found, using LibreChat default"
fi

# Copy all generated favicons
if [ -d "$FAVICON_DIR" ] && [ "$(ls -A $FAVICON_DIR/*.png 2>/dev/null)" ]; then
    echo "📋 Copying favicons..."
    cp "$FAVICON_DIR/"*.png "$LIBRECHAT_DIR/client/public/assets/"
    echo "  ✓ All favicons copied to LibreChat"
else
    echo "⚠️  No favicons found in $FAVICON_DIR"
fi

# Copy legacy SVG logo if present (for backwards compatibility)
if [ -f "$BRANDING_DIR/logo.svg" ]; then
    echo "📋 Copying legacy SVG logo..."
    cp "$BRANDING_DIR/logo.svg" "$LIBRECHAT_DIR/client/public/assets/"
    echo "  ✓ SVG logo copied"
fi

# Copy index.html
if [ -f "$BRANDING_DIR/index.html" ]; then
    echo "📋 Copying index.html..."
    cp "$BRANDING_DIR/index.html" "$LIBRECHAT_DIR/client/index.html"
    echo "  ✓ HTML metadata applied"
fi

# Copy style.css
if [ -f "$BRANDING_DIR/style.css" ]; then
    echo "📋 Copying style.css..."
    cp "$BRANDING_DIR/style.css" "$LIBRECHAT_DIR/client/src/style.css"
    echo "  ✓ CSS styling applied"
fi

echo ""
echo "✅ Branding applied successfully!"
echo ""
echo "📁 Branding files:"
echo "   Source: $SOURCE_LOGO"
echo "   Favicons: $FAVICON_DIR/"
echo "   Target: $LIBRECHAT_DIR/client/public/assets/"
