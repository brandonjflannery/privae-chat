# PrivaeChat Architecture Reorganization Plan

## 🚨 PROBLEM IDENTIFIED

**Current State Issues:**
1. ✗ LibreChat lives in `/home/mbc/dev/LibreChat/` (separate git repo)
2. ✗ PrivaeChat config is split between two directories
3. ✗ Branding files must be placed in LibreChat's directory
4. ✗ .env file is duplicated in both locations
5. ✗ Not portable - can't move PrivaeChat without LibreChat
6. ✗ Hard to update LibreChat without losing customizations

**Current Directory Structure:**
```
/home/mbc/dev/
├── LibreChat/                    ← Upstream LibreChat repo
│   ├── .git/                     ← Separate git repo
│   ├── .env                      ← Copied from privae-chat
│   ├── librechat.yaml            ← Symlinked from privae-chat
│   ├── client/
│   │   ├── public/assets/        ← BRANDING FILES HERE (not in privae-chat!)
│   │   │   ├── favicon-*.png
│   │   │   └── logo.svg
│   │   ├── index.html            ← METADATA HERE (not in privae-chat!)
│   │   └── src/
│   │       └── style.css         ← COLORS HERE (not in privae-chat!)
│   ├── api/
│   ├── package.json
│   └── node_modules/
│
└── privae-chat/                  ← PrivaeChat wrapper repo
    ├── .git/                     ← Separate git repo
    ├── .env                      ← Master config (copied to LibreChat)
    ├── librechat.yaml            ← Config (symlinked to LibreChat)
    ├── docker-compose-infra.yml  ← Infrastructure
    ├── start-services.sh         ← Service management
    ├── stop-services.sh
    ├── logs/                     ← Log output
    └── data/                     ← Persistent data (MongoDB, Redis)
```

---

## ✅ PROPOSED SOLUTION: LibreChat as Git Submodule

### Recommended Architecture

```
/home/mbc/dev/privae-chat/        ← Main project (your git repo)
├── .git/                         ← PrivaeChat git repo
├── .gitignore
├── .gitmodules                   ← Defines LibreChat submodule
│
├── librechat/                    ← LibreChat as git submodule
│   ├── .git/                     ← Points to upstream LibreChat
│   ├── client/
│   ├── api/
│   ├── package.json
│   └── ...                       ← All original LibreChat files
│
├── config/                       ← PrivaeChat-specific configs
│   ├── .env                      ← Master environment config
│   ├── librechat.yaml            ← LibreChat configuration
│   └── branding/                 ← All branding assets
│       ├── favicons/
│       │   ├── favicon-16x16.png
│       │   ├── favicon-32x32.png
│       │   ├── apple-touch-icon-180x180.png
│       │   ├── icon-192x192.png
│       │   └── maskable-icon.png
│       ├── logo.svg
│       ├── index.html            ← Custom HTML template
│       └── style.css             ← Custom color overrides
│
├── scripts/                      ← PrivaeChat management scripts
│   ├── setup.sh                  ← Initial setup
│   ├── apply-branding.sh         ← Copy branding to LibreChat
│   ├── sync-config.sh            ← Sync configs to LibreChat
│   ├── start-services.sh         ← Start everything
│   ├── stop-services.sh          ← Stop everything
│   ├── update-librechat.sh       ← Update LibreChat submodule
│   └── build.sh                  ← Build LibreChat with branding
│
├── infrastructure/               ← Infrastructure configs
│   ├── docker-compose-infra.yml  ← MongoDB, Redis, Meilisearch
│   ├── cloudflare/
│   │   ├── config.yml
│   │   ├── start-tunnel.sh
│   │   └── stop-tunnel.sh
│   └── nginx/                    ← Optional reverse proxy config
│
├── data/                         ← Persistent data
│   ├── mongodb/
│   ├── redis/
│   ├── meilisearch/
│   └── uploads/
│
├── logs/                         ← Application logs
│   ├── librechat-backend.log
│   ├── cloudflare-tunnel.log
│   └── ...
│
├── docs/                         ← Documentation
│   ├── README.md
│   ├── QUICK_START.md
│   ├── TROUBLESHOOTING.md
│   ├── BRANDING_PLAN.md
│   └── ARCHITECTURE.md           ← This file (renamed)
│
└── .env.example                  ← Example config (no secrets)
```

---

## 🎯 BENEFITS OF THIS APPROACH

### 1. **Self-Contained**
- Everything in `/home/mbc/dev/privae-chat/`
- Can move entire directory to another server
- Easy to backup: `tar -czf privae-chat-backup.tar.gz privae-chat/`

### 2. **Easy LibreChat Updates**
```bash
cd /home/mbc/dev/privae-chat
git submodule update --remote librechat
./scripts/apply-branding.sh
./scripts/build.sh
```

### 3. **Version Control**
- PrivaeChat customizations tracked in your repo
- LibreChat tracked as submodule (pinned to specific version)
- Can test new LibreChat versions safely

### 4. **Clean Separation**
- Branding assets in `config/branding/`
- Scripts in `scripts/`
- Configs in `config/`
- LibreChat untouched (just a submodule)

### 5. **Automated Deployment**
```bash
git clone --recursive https://github.com/brandonjflannery/privae-chat.git
cd privae-chat
./scripts/setup.sh
./scripts/start-services.sh --tunnel
```

---

## 🔧 IMPLEMENTATION PLAN

### Phase 1: Prepare New Structure (Without Breaking Current Setup)

**Step 1.1: Create New Directory Structure**
```bash
cd /home/mbc/dev/privae-chat

# Create new directories
mkdir -p config/branding/favicons
mkdir -p scripts
mkdir -p infrastructure/cloudflare
mkdir -p docs

# Move existing files to new locations (copies first, we'll move later)
cp .env config/.env
cp librechat.yaml config/librechat.yaml
cp docker-compose-infra.yml infrastructure/
cp cloudflare-config-privae.yml infrastructure/cloudflare/config.yml
cp start-cloudflare-tunnel.sh infrastructure/cloudflare/start-tunnel.sh
cp stop-cloudflare-tunnel.sh infrastructure/cloudflare/stop-tunnel.sh

# Move docs
cp *.md docs/
```

**Step 1.2: Extract Branding from LibreChat**
```bash
cd /home/mbc/dev/privae-chat

# Copy existing branding assets from LibreChat
cp /home/mbc/dev/LibreChat/client/public/assets/favicon-*.png config/branding/favicons/
cp /home/mbc/dev/LibreChat/client/public/assets/apple-touch-icon-*.png config/branding/favicons/
cp /home/mbc/dev/LibreChat/client/public/assets/icon-*.png config/branding/favicons/
cp /home/mbc/dev/LibreChat/client/public/assets/maskable-icon.png config/branding/favicons/
cp /home/mbc/dev/LibreChat/client/public/assets/logo.svg config/branding/

# Copy HTML and CSS templates
cp /home/mbc/dev/LibreChat/client/index.html config/branding/
cp /home/mbc/dev/LibreChat/client/src/style.css config/branding/
```

---

### Phase 2: Create Automation Scripts

**Script 1: `scripts/sync-config.sh`**
```bash
#!/bin/bash
# Syncs config files from privae-chat/config/ to librechat/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LIBRECHAT_DIR="$PROJECT_ROOT/librechat"

echo "Syncing configuration files to LibreChat..."

# Copy .env
cp "$PROJECT_ROOT/config/.env" "$LIBRECHAT_DIR/.env"
echo "✓ Synced .env"

# Copy librechat.yaml
cp "$PROJECT_ROOT/config/librechat.yaml" "$LIBRECHAT_DIR/librechat.yaml"
echo "✓ Synced librechat.yaml"

echo "Configuration sync complete!"
```

**Script 2: `scripts/apply-branding.sh`**
```bash
#!/bin/bash
# Applies branding assets from privae-chat/config/branding/ to librechat/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LIBRECHAT_DIR="$PROJECT_ROOT/librechat"
BRANDING_DIR="$PROJECT_ROOT/config/branding"

echo "Applying PrivaeChat branding to LibreChat..."

# Ensure LibreChat assets directory exists
mkdir -p "$LIBRECHAT_DIR/client/public/assets"

# Copy favicon files
echo "Copying favicons..."
cp "$BRANDING_DIR/favicons/"*.png "$LIBRECHAT_DIR/client/public/assets/"
echo "✓ Favicons applied"

# Copy logo
echo "Copying logo..."
cp "$BRANDING_DIR/logo.svg" "$LIBRECHAT_DIR/client/public/assets/"
echo "✓ Logo applied"

# Copy index.html
echo "Copying index.html..."
cp "$BRANDING_DIR/index.html" "$LIBRECHAT_DIR/client/index.html"
echo "✓ HTML metadata applied"

# Copy style.css
echo "Copying style.css..."
cp "$BRANDING_DIR/style.css" "$LIBRECHAT_DIR/client/src/style.css"
echo "✓ CSS styling applied"

echo "Branding applied successfully!"
```

**Script 3: `scripts/build.sh`**
```bash
#!/bin/bash
# Builds LibreChat with PrivaeChat branding

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LIBRECHAT_DIR="$PROJECT_ROOT/librechat"

echo "Building LibreChat with PrivaeChat branding..."

# Sync config and branding first
"$SCRIPT_DIR/sync-config.sh"
"$SCRIPT_DIR/apply-branding.sh"

# Build LibreChat
cd "$LIBRECHAT_DIR"

echo "Installing dependencies..."
npm ci

echo "Building packages..."
npm run build:packages

echo "Building data provider..."
npm run build:data-provider

echo "Building frontend..."
npm run frontend:build

echo "Build complete!"
```

**Script 4: `scripts/update-librechat.sh`**
```bash
#!/bin/bash
# Updates LibreChat submodule to latest version

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "Updating LibreChat submodule..."

cd "$PROJECT_ROOT"

# Update submodule
git submodule update --remote librechat

echo "LibreChat updated to latest version"
echo "Review changes with: cd librechat && git log"
echo "Then rebuild with: ./scripts/build.sh"
```

---

### Phase 3: Convert LibreChat to Git Submodule

**Step 3.1: Stop Services**
```bash
cd /home/mbc/dev/privae-chat
./stop-services.sh
```

**Step 3.2: Backup Current LibreChat**
```bash
cd /home/mbc/dev
mv LibreChat LibreChat.backup
```

**Step 3.3: Add LibreChat as Submodule**
```bash
cd /home/mbc/dev/privae-chat

# Add LibreChat as submodule
git submodule add https://github.com/danny-avila/LibreChat.git librechat

# Initialize submodule
git submodule update --init --recursive
```

**Step 3.4: Apply Branding and Config**
```bash
cd /home/mbc/dev/privae-chat

# Make scripts executable
chmod +x scripts/*.sh

# Sync config files
./scripts/sync-config.sh

# Apply branding
./scripts/apply-branding.sh

# Build LibreChat
./scripts/build.sh
```

---

### Phase 4: Update Service Scripts

**Updated `scripts/start-services.sh`**
```bash
#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LIBRECHAT_DIR="$PROJECT_ROOT/librechat"

# Parse flags
BUILD=false
TUNNEL=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --build) BUILD=true ;;
        --tunnel) TUNNEL=true ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

echo "Starting PrivaeChat services..."

# Build if requested
if [ "$BUILD" = true ]; then
    echo "Building LibreChat from source..."
    "$SCRIPT_DIR/build.sh"
else
    # Still sync config
    "$SCRIPT_DIR/sync-config.sh"
fi

# Start infrastructure
echo "Starting infrastructure services..."
cd "$PROJECT_ROOT/infrastructure"
docker-compose -f docker-compose-infra.yml up -d

# Wait for services
echo "Waiting for services to be ready..."
sleep 5

# Start LibreChat
echo "Starting LibreChat backend..."
cd "$LIBRECHAT_DIR"
npm run backend > "$PROJECT_ROOT/logs/librechat-backend.log" 2>&1 &
LIBRECHAT_PID=$!
echo "LIBRECHAT_PID=$LIBRECHAT_PID" > "$PROJECT_ROOT/.pids"

echo "LibreChat started with PID: $LIBRECHAT_PID"

# Start Cloudflare tunnel if requested
if [ "$TUNNEL" = true ]; then
    echo "Starting Cloudflare tunnel..."
    "$PROJECT_ROOT/infrastructure/cloudflare/start-tunnel.sh"
fi

echo "PrivaeChat services started!"
echo "Access at: http://localhost:3026"
if [ "$TUNNEL" = true ]; then
    echo "Public URL: https://privae.umbrella7.com"
fi
```

---

### Phase 5: Update .gitignore

```bash
# PrivaeChat .gitignore

# LibreChat submodule (tracked, but not its build artifacts)
librechat/node_modules/
librechat/client/dist/
librechat/client/node_modules/
librechat/api/node_modules/
librechat/.env

# Data directories
data/
logs/

# Process IDs
.pids
.tunnel.pid

# Environment files with secrets
config/.env

# OS files
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Build artifacts
*.log
```

---

### Phase 6: Update Documentation

**Updated `docs/README.md` - Installation Section**
```markdown
## Quick Start

### 1. Clone Repository
```bash
git clone --recursive https://github.com/brandonjflannery/privae-chat.git
cd privae-chat
```

The `--recursive` flag automatically clones the LibreChat submodule.

### 2. Configure Environment
```bash
cp config/.env.example config/.env
# Edit config/.env with your settings
```

### 3. Build LibreChat
```bash
./scripts/build.sh
```

### 4. Start Services
```bash
./scripts/start-services.sh --tunnel
```

### 5. Access PrivaeChat
- Local: http://localhost:3026
- Public: https://privae.umbrella7.com

## Updating LibreChat

```bash
# Update to latest LibreChat version
./scripts/update-librechat.sh

# Review changes
cd librechat && git log

# Rebuild with new version
cd ..
./scripts/build.sh

# Restart services
./scripts/stop-services.sh
./scripts/start-services.sh
```

## Custom Branding

All branding assets are in `config/branding/`:
- `favicons/` - All favicon files
- `logo.svg` - Main logo
- `index.html` - HTML metadata
- `style.css` - Custom colors

After changing branding:
```bash
./scripts/apply-branding.sh
./scripts/build.sh
```
```

---

## 📊 MIGRATION CHECKLIST

### Preparation
```
[ ] 1. Read this entire document
[ ] 2. Backup current setup: tar -czf privae-backup.tar.gz privae-chat/ LibreChat/
[ ] 3. Ensure services are stopped
[ ] 4. Commit any uncommitted changes to git
```

### Create New Structure
```
[ ] 5. Create config/ directory structure
[ ] 6. Create scripts/ directory structure
[ ] 7. Create infrastructure/ directory structure
[ ] 8. Create docs/ directory structure
[ ] 9. Copy existing files to new locations
[ ] 10. Extract branding from LibreChat
```

### Create Scripts
```
[ ] 11. Create scripts/sync-config.sh
[ ] 12. Create scripts/apply-branding.sh
[ ] 13. Create scripts/build.sh
[ ] 14. Create scripts/update-librechat.sh
[ ] 15. Create scripts/start-services.sh
[ ] 16. Create scripts/stop-services.sh
[ ] 17. Make all scripts executable
```

### Convert to Submodule
```
[ ] 18. Backup current LibreChat directory
[ ] 19. Add LibreChat as git submodule
[ ] 20. Initialize submodule
[ ] 21. Sync config files
[ ] 22. Apply branding
[ ] 23. Build LibreChat
```

### Test
```
[ ] 24. Start infrastructure services
[ ] 25. Start LibreChat backend
[ ] 26. Access http://localhost:3026
[ ] 27. Verify branding appears
[ ] 28. Verify models load
[ ] 29. Test chat functionality
[ ] 30. Start Cloudflare tunnel
[ ] 31. Test public access
```

### Cleanup
```
[ ] 32. Remove old files from root
[ ] 33. Update .gitignore
[ ] 34. Update documentation
[ ] 35. Commit reorganization to git
[ ] 36. Push to GitHub
[ ] 37. Delete LibreChat.backup (if everything works)
```

---

## 🚀 ROLLBACK PLAN

If something goes wrong:

```bash
cd /home/mbc/dev/privae-chat
./stop-services.sh

# Restore original LibreChat
cd /home/mbc/dev
rm -rf privae-chat/librechat
mv LibreChat.backup LibreChat

# Restore original configs
cd privae-chat
git checkout HEAD -- .

# Restart
./start-services.sh --tunnel
```

---

## 🎯 BENEFITS SUMMARY

| Aspect | Before | After |
|--------|--------|-------|
| **Organization** | Split across 2 dirs | All in privae-chat/ |
| **Portability** | Must copy 2 dirs | Copy 1 dir |
| **Updates** | Manual, risky | `./scripts/update-librechat.sh` |
| **Branding** | Scattered | `config/branding/` |
| **Version Control** | Unclear ownership | Clear separation |
| **Deployment** | Multi-step manual | Single script |
| **Backup** | 2 directories | 1 directory |

---

## ❓ SHOULD WE PROCEED?

**Recommendation:** YES, absolutely!

This reorganization will:
1. Make PrivaeChat truly self-contained
2. Simplify updates and maintenance
3. Enable easy deployment to other servers
4. Properly separate your customizations from upstream LibreChat
5. Make branding management much cleaner

**Time Estimate:** 1-2 hours for complete migration and testing

**Risk Level:** LOW (we have backups and a rollback plan)

---

**Next Step:** Shall I create the scripts and begin the migration?
