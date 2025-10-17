#!/bin/bash

echo "🛑 Stopping CloudFlare Tunnel"
echo "============================"

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
    echo "No tunnel PID file found"
fi

# Also check for any running cloudflared processes
CLOUDFLARED_PIDS=$(pgrep -f "cloudflared.*run")
if [ ! -z "$CLOUDFLARED_PIDS" ]; then
    echo "Found running cloudflared processes: $CLOUDFLARED_PIDS"
    read -p "Stop all cloudflared processes? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Stopping them..."
        kill $CLOUDFLARED_PIDS 2>/dev/null
    fi
fi

echo "✅ CloudFlare tunnel stopped"
