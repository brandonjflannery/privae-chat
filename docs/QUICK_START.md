# PrivaeChat - Quick Cloudflare Tunnel Setup

## Current Situation

The Docker deployment of LibreChat has proven complex due to image versioning issues. The simplest path forward is to:

1. **Use the Cloudflare tunnel setup NOW** (works independently)
2. **Fix LibreChat deployment separately** (follow official docs)

## Immediate Solution: Setup Cloudflare Tunnel

Since you're SSH'd in and can't access localhost in your browser, let's configure the Cloudflare tunnel RIGHT NOW so you can test via the public URL.

### Step 1: Run Tunnel Setup

```bash
cd /home/mbc/dev/privae-chat
./setup-cloudflare.sh
```

This will:
- Create a new tunnel for privae-chat
- Generate config files
- Give you a tunnel ID

### Step 2: Configure DNS in Browser

On your LOCAL machine (with browser access):

1. Go to: **https://dash.cloudflare.com/**
2. Login and select **umbrella7.com**
3. Navigate to: **Traffic** → **Cloudflare Tunnel**
4. Find your new tunnel
5. Click **Configure** → **Public Hostnames** → **Add**
6. Settings:
   - **Subdomain:** `privae`
   - **Domain:** `umbrella7.com`
   - **Type:** `HTTP`
   - **URL:** `localhost:3026`
7. **Save**

### Step 3: Fix LibreChat and Start Tunnel

Once LibreChat is working:

```bash
# Start tunnel
./start-cloudflare-tunnel.sh

# Access at
# https://privae.umbrella7.com
```

## Alternative: Test with DolphinDox

To test the Cloudflare tunnel setup immediately, you can temporarily point it at DolphinDox:

### Create test tunnel config:

```bash
cat > cloudflare-config-test.yml << 'EOF'
tunnel: YOUR_TUNNEL_ID_HERE
credentials-file: /home/mbc/.cloudflared/YOUR_TUNNEL_ID.json

ingress:
  - hostname: privae.umbrella7.com
    service: http://localhost:3023  # DolphinDox port
    originRequest:
      noTLSVerify: true
  - service: http_status:404
EOF
```

Then start it:
```bash
cloudflared tunnel --config cloudflare-config-test.yml run > test-tunnel.log 2>&1 &
```

This lets you test the Cloudflare setup works, then switch to LibreChat when ready.

## LibreChat Fix Options

### Option 1: Use Official Deployment (Recommended)

```bash
cd /home/mbc/dev
git clone https://github.com/danny-avila/LibreChat.git librechat-official
cd librechat-official

# Copy example files
cp .env.example .env
cp docker-compose.override.yaml.example docker-compose.override.yaml

# Edit .env - add:
PORT=3026
UID=1000
GID=1000
MEILI_MASTER_KEY=DevelopmentKey123456789

# Add ollama config to librechat.yaml

# Start
docker compose up -d
```

### Option 2: Simplest Working Setup

Use LibreChat's official Docker Compose setup without modifications, then create an nginx reverse proxy on port 3026 that forwards to LibreChat's default port 3080.

## Summary

**For Remote Access NOW:**
1. Run `./setup-cloudflare.sh`
2. Configure in Cloudflare Dashboard
3. Test with DolphinDox or wait for LibreChat fix

**For LibreChat:**
- Follow official deployment guide
- Or wait for community to fix the Docker image issues
- The npm-based approach requires too much manual build management

The Cloudflare tunnel infrastructure is ready - just needs a working application behind it!
