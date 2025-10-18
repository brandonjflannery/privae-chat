#!/bin/bash

# PrivaeChat Services Stop Script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🛑 Stopping PrivaeChat Services"
echo "================================"

# Stop LibreChat using saved PID
if [ -f .pids ]; then
    echo "📋 Reading saved PIDs..."
    source .pids

    if [ ! -z "$LIBRECHAT_PID" ]; then
        echo -n "  Stopping LibreChat (PID: $LIBRECHAT_PID)..."
        kill $LIBRECHAT_PID 2>/dev/null

        # Wait for process to stop
        for i in {1..10}; do
            if ! ps -p $LIBRECHAT_PID > /dev/null 2>&1; then
                echo -e " ${GREEN}✓${NC}"
                break
            fi
            sleep 1
        done

        # Force kill if still running
        if ps -p $LIBRECHAT_PID > /dev/null 2>&1; then
            echo -e " ${YELLOW}(force stopping)${NC}"
            kill -9 $LIBRECHAT_PID 2>/dev/null
        fi
    fi

    rm .pids
else
    echo "⚠️  No saved PIDs found, searching for processes..."

    # Try to find and stop processes by port
    echo -n "  Stopping LibreChat on port 3026..."
    LIBRECHAT_PID=$(lsof -ti:3026)
    if [ ! -z "$LIBRECHAT_PID" ]; then
        kill $LIBRECHAT_PID 2>/dev/null
        echo -e " ${GREEN}✓${NC}"
    else
        echo -e " ${YELLOW}not running${NC}"
    fi
fi

# Stop Cloudflare tunnel if running
if [ -f .tunnel.pid ]; then
    echo "🌐 Stopping Cloudflare tunnel..."
    ./stop-cloudflare-tunnel.sh
fi

# Ask user if they want to stop Docker services
echo ""
read -p "🐳 Stop Docker services (MongoDB, Meilisearch, Redis)? (y/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🐳 Stopping Docker services..."
    docker-compose -f docker-compose-infra.yml down 2>/dev/null || docker compose -f docker-compose-infra.yml down
    echo -e "  ${GREEN}✓${NC} Docker services stopped"
else
    echo "  ℹ️  Docker services left running"
    echo "  To stop manually: docker compose -f docker-compose-infra.yml down"
fi

echo ""
echo "✅ Services stopped successfully!"
echo ""
echo "📋 To restart:"
echo "  ./start-services.sh"
echo "  ./start-services.sh --install    # Reinstall dependencies"
echo "  ./start-services.sh --tunnel     # With Cloudflare tunnel"
