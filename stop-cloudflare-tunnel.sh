#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "🛑 Stopping CloudFlare Tunnel for PrivaeChat"
echo "============================================="

# Get our tunnel ID from config
TUNNEL_ID=$(grep "tunnel:" cloudflare-config-privae.yml 2>/dev/null | awk '{print $2}')

if [ -f .tunnel.pid ]; then
    source .tunnel.pid
    if [ ! -z "$TUNNEL_PID" ]; then
        echo "Stopping tunnel process (PID: $TUNNEL_PID)..."
        kill $TUNNEL_PID 2>/dev/null

        # Wait for process to stop
        for i in {1..10}; do
            if ! ps -p $TUNNEL_PID > /dev/null 2>&1; then
                echo "✓ Tunnel stopped"
                break
            fi
            sleep 1
        done

        # Force kill if still running
        if ps -p $TUNNEL_PID > /dev/null 2>&1; then
            echo "Force stopping tunnel..."
            kill -9 $TUNNEL_PID 2>/dev/null
        fi
    fi
    rm .tunnel.pid
else
    echo "⚠️  No tunnel PID file found"

    # Try to find our specific tunnel by ID
    if [ ! -z "$TUNNEL_ID" ]; then
        echo "   Looking for tunnel $TUNNEL_ID..."
        TUNNEL_PID=$(pgrep -f "cloudflared.*run.*${TUNNEL_ID}")
        if [ ! -z "$TUNNEL_PID" ]; then
            echo "   Found tunnel process (PID: $TUNNEL_PID), stopping..."
            kill $TUNNEL_PID 2>/dev/null
            sleep 2
            if ! ps -p $TUNNEL_PID > /dev/null 2>&1; then
                echo "   ✓ Tunnel stopped"
            fi
        else
            echo "   No running tunnel found for $TUNNEL_ID"
        fi
    fi
fi

echo "✅ PrivaeChat CloudFlare tunnel stopped"
echo ""
echo "ℹ️  Other CloudFlare tunnels on this system were NOT affected"
