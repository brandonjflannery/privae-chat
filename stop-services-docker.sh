#!/bin/bash

# PrivaeChat Services Stop Script (Docker Edition)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🛑 Stopping PrivaeChat Services (Docker)"
echo "========================================"

# Stop Cloudflare tunnel if running
if [ -f .tunnel.pid ]; then
    echo "🌐 Stopping Cloudflare tunnel..."
    ./stop-cloudflare-tunnel.sh
fi

# Ask user what to stop
echo ""
echo "What would you like to stop?"
echo "  1) Just LibreChat (keep infrastructure running)"
echo "  2) Everything (LibreChat + infrastructure)"
echo "  3) Cancel"
echo ""
read -p "Enter choice [1-3]: " -n 1 -r
echo ""

case $REPLY in
    1)
        echo "🐳 Stopping LibreChat only..."
        docker compose stop librechat
        echo -e "  ${GREEN}✓${NC} LibreChat stopped"
        echo ""
        echo "Infrastructure (MongoDB, Redis, Meilisearch) still running"
        echo "To restart LibreChat: docker compose start librechat"
        ;;
    2)
        echo "🐳 Stopping all services..."
        docker compose down
        echo -e "  ${GREEN}✓${NC} All services stopped"
        echo ""
        echo "To remove volumes (delete data): docker compose down -v"
        ;;
    3)
        echo "Cancelled"
        exit 0
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "✅ Services stopped successfully!"
echo ""
echo "📋 To restart:"
echo "  ./start-services-docker.sh"
echo "  ./start-services-docker.sh --tunnel   # With Cloudflare tunnel"
