#!/bin/bash
# Start PrivaeChat services

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LIBRECHAT_DIR="$PROJECT_ROOT/librechat"

# Parse flags
BUILD=false
TUNNEL=false
INSTALL=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --build) BUILD=true ;;
        --tunnel) TUNNEL=true ;;
        --install) INSTALL=true ;;
        *) echo "Unknown parameter: $1"; echo "Usage: $0 [--build] [--tunnel] [--install]"; exit 1 ;;
    esac
    shift
done

echo "🚀 Starting PrivaeChat Services"
echo "================================"
echo ""

# Build if requested
if [ "$BUILD" = true ]; then
    echo "🔨 Building LibreChat from source..."
    "$SCRIPT_DIR/build.sh"
    echo ""
elif [ "$INSTALL" = true ]; then
    echo "📦 Installing dependencies..."
    cd "$LIBRECHAT_DIR"
    npm ci
    echo ""
fi

# Always sync config before starting
echo "🔄 Syncing configuration..."
"$SCRIPT_DIR/sync-config.sh"
echo ""

# Start infrastructure
echo "🐳 Starting infrastructure services..."
cd "$PROJECT_ROOT/infrastructure"
docker compose -f docker-compose-infra.yml up -d

# Wait for services
echo "⏳ Waiting for services to be ready..."
sleep 5

# Start LibreChat
echo "💬 Starting LibreChat backend..."
cd "$LIBRECHAT_DIR"
npm run backend > "$PROJECT_ROOT/logs/librechat-backend.log" 2>&1 &
LIBRECHAT_PID=$!
echo "LIBRECHAT_PID=$LIBRECHAT_PID" > "$PROJECT_ROOT/.pids"

echo "✓ LibreChat started with PID: $LIBRECHAT_PID"

# Start Cloudflare tunnel if requested
if [ "$TUNNEL" = true ]; then
    echo ""
    echo "🌐 Starting Cloudflare tunnel..."
    "$PROJECT_ROOT/infrastructure/cloudflare/start-tunnel.sh"
fi

echo ""
echo "✅ PrivaeChat services started successfully!"
echo ""
echo "📊 Access Points:"
echo "  Local:  http://localhost:3026"
if [ "$TUNNEL" = true ]; then
    echo "  Public: https://privae.umbrella7.com"
fi
echo ""
echo "📋 Logs:"
echo "  tail -f logs/librechat-backend.log"
if [ "$TUNNEL" = true ]; then
    echo "  tail -f logs/cloudflare-tunnel.log"
fi
echo ""
echo "🛑 To stop: ./scripts/stop-services.sh"
