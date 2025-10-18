#!/bin/bash
# Syncs config files from privae-chat/config/ to librechat/

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

echo "🔄 Syncing configuration files to LibreChat..."

# Copy .env
if [ -f "$PROJECT_ROOT/config/.env" ]; then
    cp "$PROJECT_ROOT/config/.env" "$LIBRECHAT_DIR/.env"
    echo "✓ Synced .env"
else
    echo "⚠️  config/.env not found"
fi

# Copy librechat.yaml
if [ -f "$PROJECT_ROOT/config/librechat.yaml" ]; then
    cp "$PROJECT_ROOT/config/librechat.yaml" "$LIBRECHAT_DIR/librechat.yaml"
    echo "✓ Synced librechat.yaml"
else
    echo "⚠️  config/librechat.yaml not found"
fi

echo "✅ Configuration sync complete!"
