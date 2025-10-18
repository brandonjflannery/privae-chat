#!/bin/bash
# Stop PrivaeChat services

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "🛑 Stopping PrivaeChat Services"
echo "================================"
echo ""

# Stop LibreChat
if [ -f "$PROJECT_ROOT/.pids" ]; then
    echo "💬 Stopping LibreChat..."
    source "$PROJECT_ROOT/.pids"
    if [ ! -z "$LIBRECHAT_PID" ]; then
        kill $LIBRECHAT_PID 2>/dev/null || true
        echo "✓ LibreChat stopped (PID: $LIBRECHAT_PID)"
    fi
else
    echo "⚠️  No PID file found, searching for LibreChat process..."
    LIBRECHAT_PID=$(lsof -ti :3026 2>/dev/null || true)
    if [ ! -z "$LIBRECHAT_PID" ]; then
        kill $LIBRECHAT_PID 2>/dev/null || true
        echo "✓ LibreChat stopped (PID: $LIBRECHAT_PID)"
    else
        echo "✓ LibreChat not running"
    fi
fi

# Stop Cloudflare tunnel
echo ""
echo "🌐 Stopping Cloudflare tunnel..."
"$PROJECT_ROOT/infrastructure/cloudflare/stop-tunnel.sh" 2>/dev/null || echo "✓ Tunnel not running"

echo ""
echo "ℹ️  Docker services left running"
echo "  To stop: cd infrastructure && docker compose -f docker-compose-infra.yml down"

echo ""
echo "✅ Services stopped successfully!"
echo ""
echo "🚀 To restart: ./scripts/start-services.sh [--tunnel]"
