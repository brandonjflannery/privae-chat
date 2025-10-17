#!/bin/bash

# PrivaeChat Services Startup Script (Docker Edition)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Check for flags
START_TUNNEL=false

# Process all arguments
for arg in "$@"; do
    case $arg in
        --tunnel)
            START_TUNNEL=true
            echo "🌐 Will start Cloudflare tunnel after services"
            ;;
    esac
done

if [ "$START_TUNNEL" = true ]; then
    echo ""
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🚀 Starting PrivaeChat Services (Docker)"
echo "========================================"
echo "📍 Using Docker Compose"
echo "  LibreChat: :3026"
echo "  MongoDB: :27026"
echo "  Meilisearch: :7726"
echo "  Redis: :6326"
echo ""

# Check if .env exists
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}⚠️  .env file not found. Creating from .env.example...${NC}"
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo -e "${YELLOW}⚠️  Please edit .env and add your secrets${NC}"
        echo ""
        read -p "Press Enter to continue after editing .env..."
    else
        echo -e "${RED}✗ No .env.example found. Please create .env manually${NC}"
        exit 1
    fi
fi

# Check if Ollama is running
echo "🤖 Checking Ollama availability..."
if curl -s http://localhost:11434/api/tags >/dev/null 2>&1; then
    echo -e "  ${GREEN}✓${NC} Ollama is running"
else
    echo -e "  ${RED}✗${NC} Ollama is not running on localhost:11434"
    echo "  Please start Ollama before continuing"
    exit 1
fi

# Start Docker services
echo ""
echo "🐳 Starting Docker services..."
docker compose up -d

# Wait for services to be healthy
echo ""
echo "⏳ Waiting for services to be healthy..."

# Wait for MongoDB
echo -n "  MongoDB: "
for i in {1..30}; do
    if docker exec privae_mongodb mongosh --eval "db.adminCommand('ping')" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
        break
    fi
    echo -n "."
    sleep 1
done

# Wait for Meilisearch
echo -n "  Meilisearch: "
for i in {1..30}; do
    if curl -s http://localhost:7726/health >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
        break
    fi
    echo -n "."
    sleep 1
done

# Wait for Redis
echo -n "  Redis: "
for i in {1..30}; do
    if docker exec privae_redis redis-cli ping >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
        break
    fi
    echo -n "."
    sleep 1
done

# Wait for LibreChat
echo -n "  LibreChat: "
for i in {1..60}; do
    if curl -s http://localhost:3026 >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
        break
    fi
    echo -n "."
    sleep 2
done

# Check if LibreChat actually started
if ! curl -s http://localhost:3026 >/dev/null 2>&1; then
    echo -e "\n${RED}✗ LibreChat failed to start${NC}"
    echo "Check logs with: docker logs privae_librechat"
    exit 1
fi

echo ""
echo "✅ All services are ready!"
echo ""
echo "📍 Access points:"
echo "  LibreChat UI: http://localhost:3026"
echo "  MongoDB: localhost:27026"
echo "  Meilisearch: localhost:7726"
echo "  Redis: localhost:6326"
echo ""
echo "🤖 Ollama Models Available:"
echo "  - deepseek-r1:32b"
echo "  - deepseek-r1:7b"
echo "  - deepseek-r1:1.5b"
echo "  - gemma3:27b"
echo ""
echo "📋 Commands:"
echo "  Stop all: ./stop-services-docker.sh"
echo "  View logs: docker compose logs -f"
echo "  View LibreChat logs: docker logs -f privae_librechat"
echo "  Restart: docker compose restart librechat"
echo ""

# Start Cloudflare tunnel if requested
if [ "$START_TUNNEL" = true ]; then
    echo "🌐 Starting Cloudflare tunnel..."
    ./start-cloudflare-tunnel.sh

    if [ $? -eq 0 ]; then
        echo ""
        echo "🌍 Your application is now accessible at:"
        echo "  https://privae.umbrella7.com"
        echo ""
        echo "📋 Tunnel commands:"
        echo "  Stop tunnel: ./stop-cloudflare-tunnel.sh"
        echo "  View tunnel logs: tail -f cloudflare-tunnel.log"
    else
        echo -e "${RED}✗${NC} Failed to start Cloudflare tunnel"
    fi
fi
