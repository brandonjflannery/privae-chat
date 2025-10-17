#!/bin/bash

# PrivaeChat Services Startup Script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Check for flags
START_TUNNEL=false
INSTALL_DEPS=false

# Process all arguments
for arg in "$@"; do
    case $arg in
        --tunnel)
            START_TUNNEL=true
            echo "🌐 Will start Cloudflare tunnel after services"
            ;;
        --install)
            INSTALL_DEPS=true
            echo "📦 Will install/update dependencies"
            ;;
    esac
done

if [ "$START_TUNNEL" = true ] || [ "$INSTALL_DEPS" = true ]; then
    echo ""
fi

# Define ports
MONGODB_PORT=27026
MEILISEARCH_PORT=7726
REDIS_PORT=6326
LIBRECHAT_PORT=3026

# LibreChat directory
LIBRECHAT_DIR="../LibreChat"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🚀 Starting PrivaeChat Services"
echo "=================================="
echo "📍 Using configured ports:"
echo "  MongoDB: $MONGODB_PORT"
echo "  Meilisearch: $MEILISEARCH_PORT"
echo "  Redis: $REDIS_PORT"
echo "  LibreChat: $LIBRECHAT_PORT"
echo ""

# Function to check if a port is in use
check_port() {
    local port=$1
    if lsof -i :$port >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Check if Docker services are running
echo "🐳 Starting Docker infrastructure..."
docker-compose -f docker-compose-infra.yml up -d 2>/dev/null || docker compose -f docker-compose-infra.yml up -d

# Wait for services to be healthy
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
    if curl -s http://localhost:$MEILISEARCH_PORT/health >/dev/null 2>&1; then
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

# Check if LibreChat directory exists
if [ ! -d "$LIBRECHAT_DIR" ]; then
    echo -e "${RED}✗ LibreChat directory not found at $LIBRECHAT_DIR${NC}"
    echo "Please clone LibreChat first:"
    echo "  cd /home/mbc/dev && git clone https://github.com/danny-avila/LibreChat.git"
    exit 1
fi

echo ""
echo "📦 Setting up LibreChat..."
cd "$LIBRECHAT_DIR"

# Copy configuration files
echo "  Copying configuration files..."
cp "$SCRIPT_DIR/.env" .env
cp "$SCRIPT_DIR/librechat.yaml" librechat.yaml

# Install/update dependencies if requested or if node_modules doesn't exist
if [ "$INSTALL_DEPS" = true ] || [ ! -d "node_modules" ]; then
    echo "  Installing dependencies (this may take a few minutes)..."
    npm ci > "$SCRIPT_DIR/logs/npm-install.log" 2>&1

    if [ $? -ne 0 ]; then
        echo -e "  ${RED}✗${NC} npm install failed - check logs/npm-install.log"
        cd "$SCRIPT_DIR"
        exit 1
    fi
    echo -e "  ${GREEN}✓${NC} Dependencies installed"
else
    echo "  ℹ️  Using existing node_modules (use --install to reinstall)"
fi

# Check if LibreChat is already running
if check_port $LIBRECHAT_PORT; then
    echo -e "${YELLOW}⚠️  LibreChat appears to be already running on port $LIBRECHAT_PORT${NC}"
    echo "  Run ./stop-services.sh first if you want to restart"
    cd "$SCRIPT_DIR"
    exit 1
fi

# Start LibreChat
echo "🚀 Starting LibreChat on port $LIBRECHAT_PORT..."
npm run backend > "$SCRIPT_DIR/logs/librechat-backend.log" 2>&1 &
LIBRECHAT_PID=$!

cd "$SCRIPT_DIR"

# Save PID
echo "LIBRECHAT_PID=$LIBRECHAT_PID" > .pids

# Wait for LibreChat to be ready
echo -n "  Waiting for LibreChat: "
for i in {1..60}; do
    if curl -s http://localhost:$LIBRECHAT_PORT >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
        break
    fi
    echo -n "."
    sleep 2
done

# Check if it actually started
if ! curl -s http://localhost:$LIBRECHAT_PORT >/dev/null 2>&1; then
    echo -e "\n${RED}✗ LibreChat failed to start - check logs/librechat-backend.log${NC}"
    tail -20 logs/librechat-backend.log
    exit 1
fi

echo ""
echo "✅ All services are ready!"
echo ""
echo "📍 Access points:"
echo "  LibreChat UI: http://localhost:$LIBRECHAT_PORT"
echo "  API Health: http://localhost:$LIBRECHAT_PORT/api/health"
echo ""
echo "🤖 Ollama Models Available:"
echo "  - deepseek-r1:32b"
echo "  - deepseek-r1:7b"
echo "  - deepseek-r1:1.5b"
echo "  - gemma3:27b"
echo ""
echo "📋 Commands:"
echo "  Stop all: ./stop-services.sh"
echo "  View logs: tail -f logs/librechat-backend.log"
echo "  View Docker logs: docker compose -f docker-compose-infra.yml logs -f"
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
