#!/bin/bash
# PrivaeChat Migration Script
# Migrates from old structure to new organized structure with LibreChat as submodule

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LIBRECHAT_EXTERNAL="/home/mbc/dev/LibreChat"

echo "🔄 PrivaeChat Structure Migration"
echo "=================================="
echo ""

# Step 1: Move config files
echo "📁 Moving configuration files..."
cp "$PROJECT_ROOT/.env" "$PROJECT_ROOT/config/.env"
cp "$PROJECT_ROOT/librechat.yaml" "$PROJECT_ROOT/config/librechat.yaml"
cp "$PROJECT_ROOT/.env.example" "$PROJECT_ROOT/config/.env.example"
echo "✓ Config files moved"

# Step 2: Move infrastructure files
echo "📁 Moving infrastructure files..."
cp "$PROJECT_ROOT/docker-compose-infra.yml" "$PROJECT_ROOT/infrastructure/docker-compose-infra.yml"
cp "$PROJECT_ROOT/cloudflare-config-privae.yml" "$PROJECT_ROOT/infrastructure/cloudflare/config.yml"
cp "$PROJECT_ROOT/start-cloudflare-tunnel.sh" "$PROJECT_ROOT/infrastructure/cloudflare/start-tunnel.sh"
cp "$PROJECT_ROOT/stop-cloudflare-tunnel.sh" "$PROJECT_ROOT/infrastructure/cloudflare/stop-tunnel.sh"
chmod +x "$PROJECT_ROOT/infrastructure/cloudflare/"*.sh
echo "✓ Infrastructure files moved"

# Step 3: Move documentation
echo "📁 Moving documentation..."
for doc in README.md QUICK_START.md TROUBLESHOOTING.md IMPLEMENTATION_REVIEW.md CLOUDFLARE_SETUP.md BRANDING_PLAN.md BRANDING_VISUAL_GUIDE.md ARCHITECTURE_REORGANIZATION.md; do
    if [ -f "$PROJECT_ROOT/$doc" ]; then
        cp "$PROJECT_ROOT/$doc" "$PROJECT_ROOT/docs/"
    fi
done
echo "✓ Documentation moved"

# Step 4: Extract branding from LibreChat
echo "🎨 Extracting branding assets from LibreChat..."
if [ -d "$LIBRECHAT_EXTERNAL/client/public/assets" ]; then
    cp "$LIBRECHAT_EXTERNAL/client/public/assets/favicon-"*.png "$PROJECT_ROOT/config/branding/favicons/" 2>/dev/null || true
    cp "$LIBRECHAT_EXTERNAL/client/public/assets/apple-touch-icon-"*.png "$PROJECT_ROOT/config/branding/favicons/" 2>/dev/null || true
    cp "$LIBRECHAT_EXTERNAL/client/public/assets/icon-"*.png "$PROJECT_ROOT/config/branding/favicons/" 2>/dev/null || true
    cp "$LIBRECHAT_EXTERNAL/client/public/assets/maskable-icon.png" "$PROJECT_ROOT/config/branding/favicons/" 2>/dev/null || true
    cp "$LIBRECHAT_EXTERNAL/client/public/assets/logo.svg" "$PROJECT_ROOT/config/branding/" 2>/dev/null || true
fi

if [ -f "$LIBRECHAT_EXTERNAL/client/index.html" ]; then
    cp "$LIBRECHAT_EXTERNAL/client/index.html" "$PROJECT_ROOT/config/branding/"
fi

if [ -f "$LIBRECHAT_EXTERNAL/client/src/style.css" ]; then
    cp "$LIBRECHAT_EXTERNAL/client/src/style.css" "$PROJECT_ROOT/config/branding/"
fi

echo "✓ Branding assets extracted"

# Step 5: Move service scripts to scripts directory
echo "📁 Moving service scripts..."
cp "$PROJECT_ROOT/start-services.sh" "$PROJECT_ROOT/scripts/start-services.sh.old"
cp "$PROJECT_ROOT/stop-services.sh" "$PROJECT_ROOT/scripts/stop-services.sh.old"
echo "✓ Service scripts backed up"

echo ""
echo "✅ Migration preparation complete!"
echo ""
echo "Next steps:"
echo "1. Add LibreChat as submodule: git submodule add https://github.com/danny-avila/LibreChat.git librechat"
echo "2. Create automation scripts (sync-config.sh, apply-branding.sh, build.sh)"
echo "3. Update service scripts to use new structure"
echo "4. Test and commit"
