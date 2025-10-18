#!/bin/bash
# Applies branding assets from privae-chat/config/branding/ to librechat/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LIBRECHAT_DIR="$PROJECT_ROOT/librechat"
BRANDING_DIR="$PROJECT_ROOT/config/branding"

# Check if LibreChat directory exists
if [ ! -d "$LIBRECHAT_DIR" ]; then
    echo "❌ LibreChat directory not found at $LIBRECHAT_DIR"
    exit 1
fi

echo "🎨 Applying PrivaeChat branding to LibreChat..."

# Ensure LibreChat assets directory exists
mkdir -p "$LIBRECHAT_DIR/client/public/assets"

# Copy favicon files
if [ -d "$BRANDING_DIR/favicons" ]; then
    echo "Copying favicons..."
    cp "$BRANDING_DIR/favicons/"*.png "$LIBRECHAT_DIR/client/public/assets/" 2>/dev/null || echo "⚠️  No favicons found"
    echo "✓ Favicons applied"
fi

# Copy logo
if [ -f "$BRANDING_DIR/logo.svg" ]; then
    echo "Copying logo..."
    cp "$BRANDING_DIR/logo.svg" "$LIBRECHAT_DIR/client/public/assets/"
    echo "✓ Logo applied"
else
    echo "⚠️  logo.svg not found, using LibreChat default"
fi

# Copy index.html
if [ -f "$BRANDING_DIR/index.html" ]; then
    echo "Copying index.html..."
    cp "$BRANDING_DIR/index.html" "$LIBRECHAT_DIR/client/index.html"
    echo "✓ HTML metadata applied"
else
    echo "⚠️  index.html not found, using LibreChat default"
fi

# Copy style.css
if [ -f "$BRANDING_DIR/style.css" ]; then
    echo "Copying style.css..."
    cp "$BRANDING_DIR/style.css" "$LIBRECHAT_DIR/client/src/style.css"
    echo "✓ CSS styling applied"
else
    echo "⚠️  style.css not found, using LibreChat default"
fi

echo "✅ Branding applied successfully!"
