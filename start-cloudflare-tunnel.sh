#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "🌐 Starting CloudFlare Tunnel for PrivaeChat"
echo "============================================"

# Check if config exists
if [ ! -f "cloudflare-config-privae.yml" ]; then
    echo "❌ CloudFlare configuration not found!"
    echo "   Please run ./setup-cloudflare.sh first"
    exit 1
fi

# Extract tunnel ID and hostname from config
TUNNEL_ID=$(grep "tunnel:" cloudflare-config-privae.yml | awk '{print $2}')
HOSTNAME=$(grep "hostname:" cloudflare-config-privae.yml | head -1 | awk '{print $2}')

# Check if tunnel is already running
if pgrep -f "cloudflared.*run.*${TUNNEL_ID}" > /dev/null; then
    echo "⚠️  CloudFlare tunnel appears to be already running"
    echo "   Run ./stop-cloudflare-tunnel.sh first if you want to restart"
    exit 1
fi

# Start the tunnel
echo "🚀 Starting tunnel..."
cloudflared tunnel --config cloudflare-config-privae.yml run > cloudflare-tunnel.log 2>&1 &
TUNNEL_PID=$!

echo "TUNNEL_PID=$TUNNEL_PID" > .tunnel.pid

# Wait for tunnel to start
echo -n "⏳ Waiting for tunnel to connect"
for i in {1..30}; do
    if grep -q "Registered tunnel connection" cloudflare-tunnel.log 2>/dev/null; then
        echo ""
        echo -e "\033[0;32m✓ Tunnel connected successfully!\033[0m"
        break
    fi
    echo -n "."
    sleep 1
done

if ! grep -q "Registered tunnel connection" cloudflare-tunnel.log 2>/dev/null; then
    echo ""
    echo -e "\033[0;31m✗ Tunnel failed to connect\033[0m"
    echo "Check cloudflare-tunnel.log for details"
    kill $TUNNEL_PID 2>/dev/null
    rm .tunnel.pid
    exit 1
fi

echo ""
echo "🌐 Your PrivaeChat instance is now accessible at:"
echo "   https://$HOSTNAME"
echo ""
echo "📋 Tunnel Details:"
echo "   Tunnel ID: $TUNNEL_ID"
echo "   Process ID: $TUNNEL_PID"
echo "   Logs: tail -f cloudflare-tunnel.log"
echo ""
echo "To stop the tunnel: ./stop-cloudflare-tunnel.sh"
