# PrivaeChat - LibreChat with Ollama Integration

Private AI chat interface powered by [LibreChat](https://github.com/danny-avila/LibreChat) and local Ollama models, accessible via Cloudflare tunnel at `privae.umbrella7.com`.

## Project Overview

This project provides a complete deployment of LibreChat configured to use your local Ollama instance, with infrastructure services running in Docker and LibreChat running locally for flexibility.

### Architecture Components

- **LibreChat API** (Node.js backend) - Port: 3026
- **LibreChat Frontend** (React app) - Port: 3026 (served by backend)
- **MongoDB** - Port: 27026 (database)
- **Meilisearch** - Port: 7726 (search indexing)
- **Redis** - Port: 6326 (caching & rate limiting)
- **Ollama** (existing) - Port: 11434
- **Cloudflare Tunnel** - Routes privae.umbrella7.com to localhost:3026

### Port Strategy

All ports use suffix `26` to avoid conflicts with other services:
- MongoDB: 27026
- Redis: 6326
- Meilisearch: 7726
- LibreChat: 3026

## Directory Structure

```
privae-chat/
├── docker-compose.infrastructure.yml  # MongoDB, Meilisearch, Redis
├── .env                               # Environment configuration
├── librechat.yaml                     # LibreChat & Ollama config
├── cloudflare-config-privae.yml       # Cloudflare tunnel config (generated)
├── start-services.sh                  # Main startup script
├── stop-services.sh                   # Shutdown script
├── setup-cloudflare.sh                # Initial tunnel setup
├── start-cloudflare-tunnel.sh         # Tunnel startup (generated)
├── stop-cloudflare-tunnel.sh          # Tunnel shutdown (generated)
├── data/                              # Persistent storage
│   ├── mongodb/
│   ├── meilisearch/
│   └── redis/
└── logs/                              # Service logs
    ├── librechat.log
    └── npm-install.log
```

## Available Ollama Models

- **deepseek-r1:32b** - Primary reasoning model
- **deepseek-r1:7b** - Faster reasoning model
- **deepseek-r1:1.5b** - Lightweight model
- **gemma3:27b** - Alternative large model

## Quick Start

### 1. Start Infrastructure & LibreChat

```bash
./start-services.sh --install
```

This will:
- Start Docker services (MongoDB, Meilisearch, Redis)
- Install LibreChat dependencies (first time only)
- Start LibreChat backend
- Wait for all services to be healthy

**Flags:**
- `--install`: Force reinstall dependencies
- `--tunnel`: Also start Cloudflare tunnel after services

### 2. Access LibreChat

Once started, access LibreChat at:
- Local: http://localhost:3026
- After tunnel setup: https://privae.umbrella7.com

### 3. Stop Services

```bash
./stop-services.sh
```

You'll be prompted whether to stop Docker infrastructure.

## Cloudflare Tunnel Setup

### Initial Setup (One Time)

1. Run the setup script:
```bash
./setup-cloudflare.sh
```

2. Follow the prompts to:
   - Install cloudflared (if needed)
   - Login to Cloudflare
   - Create a new tunnel
   - Generate configuration files

3. **Configure DNS in Cloudflare Dashboard:**

   a. Go to https://dash.cloudflare.com/

   b. Select your domain: **umbrella7.com**

   c. Navigate to: **Traffic** → **Cloudflare Tunnel**

   d. Find your tunnel (look for the tunnel ID from setup)

   e. Click **Configure** → **Public Hostnames** → **Add a public hostname**

   f. Enter:
      - **Subdomain:** `privae`
      - **Domain:** `umbrella7.com`
      - **Type:** HTTP
      - **URL:** `localhost:3026`

   g. Click **Save**

4. Start the tunnel:
```bash
./start-cloudflare-tunnel.sh
```

5. Your app is now live at: **https://privae.umbrella7.com**

### Starting with Tunnel

After initial setup, you can start everything including the tunnel:

```bash
./start-services.sh --tunnel
```

Or start tunnel separately:

```bash
./start-cloudflare-tunnel.sh
```

### Stopping Tunnel

```bash
./stop-cloudflare-tunnel.sh
```

## Configuration

### Environment Variables (.env)

Key settings:
- `PORT=3026` - LibreChat port
- `MONGO_URI=mongodb://127.0.0.1:27026/LibreChat` - Database
- `ENDPOINTS=ollama` - Enable Ollama
- `ALLOW_REGISTRATION=true` - User registration enabled
- `ENABLE_FILE_UPLOADS=true` - File uploads enabled

See `.env` for all options.

### LibreChat Configuration (librechat.yaml)

Ollama endpoint configured with:
- Base URL: `http://localhost:11434/v1/`
- Model fetching enabled (auto-detect models)
- All your installed Ollama models available
- File uploads supported
- Conversation search enabled

## Features Enabled

✅ User registration & authentication
✅ Conversation search (Meilisearch)
✅ File uploads & attachments
✅ Image uploads
✅ Rate limiting (Redis)
✅ All Ollama models available
✅ Cloudflare tunnel access

## Troubleshooting

### Services won't start

Check logs:
```bash
# LibreChat logs
tail -f logs/librechat.log

# Docker logs
docker-compose -f docker-compose.infrastructure.yml logs -f

# Check service status
docker ps
```

### Port conflicts

If ports 27026, 6326, 7726, or 3026 are in use:
```bash
# Find what's using the port
lsof -i :3026

# Kill the process
kill <PID>
```

### Ollama not connecting

Verify Ollama is running:
```bash
curl http://localhost:11434/api/tags
```

### Clear data and restart

```bash
./stop-services.sh
# Answer 'y' to stop Docker services
rm -rf data/*
./start-services.sh --install
```

## Development

### Rebuild dependencies

```bash
./start-services.sh --install
```

### Check service health

```bash
# MongoDB
docker exec privae_mongodb mongosh --eval "db.adminCommand('ping')"

# Redis
docker exec privae_redis redis-cli ping

# Meilisearch
curl http://localhost:7726/health

# LibreChat
curl http://localhost:3026/api/health
```

## Security Notes

- JWT secrets are generated and stored in `.env`
- Default secrets should be changed for production
- Consider adding Cloudflare Access policies
- User registration is enabled - restrict via `ALLOW_REGISTRATION=false` if needed

## Links

- LibreChat Documentation: https://www.librechat.ai/docs
- Ollama Documentation: https://ollama.ai/docs
- Cloudflare Tunnel Docs: https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/

## License

This configuration inherits licenses from:
- LibreChat: MIT License
- Configuration files: Use freely
