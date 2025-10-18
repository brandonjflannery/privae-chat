#!/bin/bash
# Builds LibreChat with PrivaeChat branding

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LIBRECHAT_DIR="$PROJECT_ROOT/librechat"

# Check if LibreChat directory exists
if [ ! -d "$LIBRECHAT_DIR" ]; then
    echo "❌ LibreChat directory not found at $LIBRECHAT_DIR"
    echo "Please run: git submodule update --init --recursive"
    exit 1
fi

echo "🔨 Building LibreChat with PrivaeChat branding..."
echo ""

# Sync config and branding first
"$SCRIPT_DIR/sync-config.sh"
echo ""
"$SCRIPT_DIR/apply-branding.sh"
echo ""

# Build LibreChat
cd "$LIBRECHAT_DIR"

echo "📦 Installing dependencies..."
npm ci --quiet

echo "🔨 Building packages..."
npm run build:packages

echo "🎨 Building frontend..."
cd client && npm run build:ci

echo ""
echo "✅ Build complete!"
echo "Start services with: ./scripts/start-services.sh"
