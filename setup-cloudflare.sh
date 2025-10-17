#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🌐 CloudFlare Tunnel Setup for PrivaeChat"
echo "=========================================="
echo ""

# Check if cloudflared is installed
if ! command -v cloudflared &> /dev/null; then
    echo -e "${YELLOW}CloudFlare daemon (cloudflared) not found.${NC}"
    echo "Would you like to install it now? (y/n)"
    read -r response

    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "Installing cloudflared..."

        # Detect OS and architecture
        OS=$(uname -s | tr '[:upper:]' '[:lower:]')
        ARCH=$(uname -m)

        if [[ "$ARCH" == "x86_64" ]]; then
            ARCH="amd64"
        elif [[ "$ARCH" == "aarch64" ]]; then
            ARCH="arm64"
        fi

        # Download and install cloudflared
        if [[ "$OS" == "linux" ]]; then
            wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${ARCH}.deb
            sudo dpkg -i cloudflared-linux-${ARCH}.deb
            rm cloudflared-linux-${ARCH}.deb
        elif [[ "$OS" == "darwin" ]]; then
            brew install cloudflare/cloudflare/cloudflared
        else
            echo -e "${RED}Unsupported operating system. Please install cloudflared manually.${NC}"
            echo "Visit: https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/installation/"
            exit 1
        fi

        # Verify installation
        if command -v cloudflared &> /dev/null; then
            echo -e "${GREEN}✓ cloudflared installed successfully${NC}"
        else
            echo -e "${RED}✗ Failed to install cloudflared${NC}"
            exit 1
        fi
    else
        echo "Please install cloudflared manually and run this script again."
        echo "Visit: https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/installation/"
        exit 1
    fi
fi

echo -e "${GREEN}✓ cloudflared is installed${NC}"
echo ""

# Check if user is logged in
echo "Checking CloudFlare login status..."
if ! cloudflared tunnel list &> /dev/null; then
    echo -e "${YELLOW}You need to login to CloudFlare.${NC}"
    echo "This will open a browser window for authentication."
    echo "Press Enter to continue..."
    read -r

    cloudflared tunnel login

    if ! cloudflared tunnel list &> /dev/null; then
        echo -e "${RED}✗ Failed to login to CloudFlare${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ Logged in to CloudFlare${NC}"
echo ""

# Create tunnel
echo "Creating CloudFlare tunnel for PrivaeChat..."
echo "Enter a name for your tunnel (e.g., privae-chat):"
read -r TUNNEL_NAME

if [[ -z "$TUNNEL_NAME" ]]; then
    TUNNEL_NAME="privae-chat-$(date +%s)"
    echo "Using generated name: $TUNNEL_NAME"
fi

# Create the tunnel
TUNNEL_OUTPUT=$(cloudflared tunnel create "$TUNNEL_NAME" 2>&1)
if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}✓ Tunnel '$TUNNEL_NAME' created successfully${NC}"

    # Extract tunnel ID from output
    TUNNEL_ID=$(echo "$TUNNEL_OUTPUT" | grep -oE '[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}' | head -1)

    if [[ -z "$TUNNEL_ID" ]]; then
        # Try to get it from the list
        TUNNEL_ID=$(cloudflared tunnel list | grep "$TUNNEL_NAME" | awk '{print $1}')
    fi

    echo "Tunnel ID: $TUNNEL_ID"
else
    echo -e "${RED}✗ Failed to create tunnel${NC}"
    echo "Error: $TUNNEL_OUTPUT"

    # Check if tunnel already exists
    if echo "$TUNNEL_OUTPUT" | grep -q "already exists"; then
        echo ""
        echo "Tunnel with this name already exists. Fetching its ID..."
        TUNNEL_ID=$(cloudflared tunnel list | grep "$TUNNEL_NAME" | awk '{print $1}')
        if [[ -n "$TUNNEL_ID" ]]; then
            echo -e "${GREEN}✓ Found existing tunnel ID: $TUNNEL_ID${NC}"
        else
            echo -e "${RED}✗ Could not find tunnel ID${NC}"
            exit 1
        fi
    else
        exit 1
    fi
fi

# Create config file
echo ""
echo "Creating tunnel configuration..."

# Create the config file
cat > cloudflare-config-privae.yml << EOF
tunnel: $TUNNEL_ID
credentials-file: $HOME/.cloudflared/${TUNNEL_ID}.json

ingress:
  # LibreChat API endpoints
  - hostname: privae.umbrella7.com
    path: /api/*
    service: http://localhost:3026
    originRequest:
      noTLSVerify: true

  # Socket.io for real-time features
  - hostname: privae.umbrella7.com
    path: /socket.io/*
    service: http://localhost:3026
    originRequest:
      noTLSVerify: true

  # Main frontend (everything else)
  - hostname: privae.umbrella7.com
    service: http://localhost:3026
    originRequest:
      noTLSVerify: true

  # Catch-all rule
  - service: http_status:404
EOF

echo -e "${GREEN}✓ Configuration file created: cloudflare-config-privae.yml${NC}"

# Create start script
cat > start-cloudflare-tunnel.sh << 'EOF'
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
EOF

chmod +x start-cloudflare-tunnel.sh

# Create stop script
cat > stop-cloudflare-tunnel.sh << 'EOF'
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
EOF

chmod +x stop-cloudflare-tunnel.sh

# Final instructions
echo ""
echo "🎉 CloudFlare Tunnel setup complete!"
echo ""
echo "📋 IMPORTANT NEXT STEPS:"
echo ""
echo "1. Configure DNS in CloudFlare Dashboard:"
echo "   - Go to https://dash.cloudflare.com/"
echo "   - Select your domain (umbrella7.com)"
echo "   - Go to 'Traffic' -> 'Cloudflare Tunnel'"
echo "   - Find tunnel: $TUNNEL_NAME (ID: $TUNNEL_ID)"
echo "   - Add public hostname: privae.umbrella7.com -> http://localhost:3026"
echo ""
echo "2. Start your services:"
echo "   ./start-services.sh --install"
echo ""
echo "3. Start the tunnel:"
echo "   ./start-cloudflare-tunnel.sh"
echo ""
echo "Your tunnel will be accessible at: https://privae.umbrella7.com"
echo ""
