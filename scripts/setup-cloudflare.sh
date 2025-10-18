#!/bin/bash
# Setup Cloudflare Tunnel for PrivaeChat

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CLOUDFLARE_DIR="$PROJECT_ROOT/infrastructure/cloudflare"

# Change to cloudflare directory for config file creation
cd "$CLOUDFLARE_DIR"

echo "🌐 CloudFlare Tunnel Setup for PrivaeChat"
echo "=========================================="
echo ""

# Check if cloudflared is installed
if ! command -v cloudflared &> /dev/null; then
    echo "❌ cloudflared is not installed!"
    echo ""
    echo "Please install cloudflared first:"
    echo "  Ubuntu/Debian:"
    echo "    wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb"
    echo "    sudo dpkg -i cloudflared-linux-amd64.deb"
    echo ""
    echo "  Or via package manager:"
    echo "    curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-archive-keyring.gpg >/dev/null"
    echo "    echo \"deb [signed-by=/usr/share/keyrings/cloudflare-archive-keyring.gpg] https://pkg.cloudflare.com/cloudflared \$(lsb_release -cs) main\" | sudo tee /etc/apt/sources.list.d/cloudflared.list"
    echo "    sudo apt-get update && sudo apt-get install cloudflared"
    exit 1
fi

echo "✓ cloudflared is installed ($(cloudflared --version))"
echo ""

# Check if already configured
if [ -f "cloudflare-config-privae.yml" ]; then
    echo "⚠️  CloudFlare tunnel configuration already exists!"
    echo ""
    read -p "Do you want to reconfigure? This will overwrite existing config (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Setup cancelled."
        exit 0
    fi
fi

# Get user input
echo "📝 Please provide the following information:"
echo ""

# Check if user is already authenticated
if [ ! -d "$HOME/.cloudflared" ]; then
    echo "You need to authenticate with Cloudflare first."
    echo "This will open a browser window for authentication."
    read -p "Press Enter to continue..."
    cloudflared tunnel login
    echo ""
fi

# Get tunnel name
DEFAULT_TUNNEL_NAME="privae-chat"
read -p "Tunnel name [$DEFAULT_TUNNEL_NAME]: " TUNNEL_NAME
TUNNEL_NAME=${TUNNEL_NAME:-$DEFAULT_TUNNEL_NAME}

# Get hostname
DEFAULT_HOSTNAME="privae.umbrella7.com"
read -p "Public hostname (e.g., privae.yourdomain.com) [$DEFAULT_HOSTNAME]: " HOSTNAME
HOSTNAME=${HOSTNAME:-$DEFAULT_HOSTNAME}

# Get local port
DEFAULT_PORT="3026"
read -p "Local LibreChat port [$DEFAULT_PORT]: " LOCAL_PORT
LOCAL_PORT=${LOCAL_PORT:-$DEFAULT_PORT}

echo ""
echo "🔧 Configuration Summary:"
echo "  Tunnel name: $TUNNEL_NAME"
echo "  Hostname: $HOSTNAME"
echo "  Local port: $LOCAL_PORT"
echo ""
read -p "Proceed with this configuration? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Setup cancelled."
    exit 0
fi

echo ""
echo "🚀 Creating tunnel..."

# Check if tunnel already exists
EXISTING_TUNNEL=$(cloudflared tunnel list | grep "$TUNNEL_NAME" | awk '{print $1}' || true)

if [ -n "$EXISTING_TUNNEL" ]; then
    echo "ℹ️  Tunnel '$TUNNEL_NAME' already exists with ID: $EXISTING_TUNNEL"
    TUNNEL_ID="$EXISTING_TUNNEL"
else
    # Create new tunnel
    TUNNEL_ID=$(cloudflared tunnel create "$TUNNEL_NAME" | grep "Created tunnel" | awk '{print $3}')
    echo "✓ Created tunnel with ID: $TUNNEL_ID"
fi

# Get credentials file path
CREDS_FILE="$HOME/.cloudflared/$TUNNEL_ID.json"

if [ ! -f "$CREDS_FILE" ]; then
    echo "❌ Credentials file not found at: $CREDS_FILE"
    echo "Please check your Cloudflare setup."
    exit 1
fi

echo "✓ Found credentials file"

# Create config file
echo ""
echo "📝 Creating configuration file..."

cat > cloudflare-config-privae.yml << EOF
tunnel: $TUNNEL_ID
credentials-file: $CREDS_FILE

ingress:
  # LibreChat API endpoints
  - hostname: $HOSTNAME
    path: /api/*
    service: http://localhost:$LOCAL_PORT
    originRequest:
      noTLSVerify: true

  # Socket.io for real-time features
  - hostname: $HOSTNAME
    path: /socket.io/*
    service: http://localhost:$LOCAL_PORT
    originRequest:
      noTLSVerify: true

  # Main frontend (everything else)
  - hostname: $HOSTNAME
    service: http://localhost:$LOCAL_PORT
    originRequest:
      noTLSVerify: true

  # Catch-all rule
  - service: http_status:404
EOF

echo "✓ Configuration file created: cloudflare-config-privae.yml"

# Create DNS record
echo ""
echo "🌍 Setting up DNS record..."
echo "This will create a CNAME record pointing $HOSTNAME to your tunnel."
echo ""

# Check if DNS record already exists
EXISTING_DNS=$(cloudflared tunnel route dns "$TUNNEL_NAME" "$HOSTNAME" 2>&1 || true)

if echo "$EXISTING_DNS" | grep -q "already exists"; then
    echo "ℹ️  DNS record for $HOSTNAME already exists"
elif echo "$EXISTING_DNS" | grep -q "Created CNAME record"; then
    echo "✓ DNS record created successfully"
else
    echo "⚠️  Could not verify DNS record status"
    echo "You may need to manually create a CNAME record:"
    echo "  $HOSTNAME -> $TUNNEL_ID.cfargotunnel.com"
fi

echo ""
echo "✅ CloudFlare tunnel setup complete!"
echo ""
echo "📋 Tunnel Details:"
echo "  Name: $TUNNEL_NAME"
echo "  ID: $TUNNEL_ID"
echo "  Hostname: https://$HOSTNAME"
echo "  Config: $SCRIPT_DIR/cloudflare-config-privae.yml"
echo ""
echo "🚀 Next Steps:"
echo "  1. Start services with tunnel: $SCRIPT_DIR/start-services.sh --tunnel"
echo "  2. Or start tunnel manually: $CLOUDFLARE_DIR/start-tunnel.sh"
echo ""
echo "📖 Useful Commands:"
echo "  List tunnels: cloudflared tunnel list"
echo "  View tunnel info: cloudflared tunnel info $TUNNEL_NAME"
echo "  Delete tunnel: cloudflared tunnel delete $TUNNEL_NAME"
echo ""
