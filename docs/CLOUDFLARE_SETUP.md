# Cloudflare Tunnel Setup Instructions

Complete guide to configure Cloudflare Tunnel for accessing PrivaeChat at `privae.umbrella7.com`.

## Prerequisites

- Cloudflare account with access to `umbrella7.com` domain
- PrivaeChat services running (`./start-services.sh`)
- `cloudflared` CLI installed (script will help install)

## Step 1: Run Setup Script

```bash
cd /home/mbc/dev/privae-chat
./setup-cloudflare.sh
```

The script will:
1. ✅ Check/install `cloudflared` CLI
2. ✅ Login to Cloudflare (opens browser)
3. ✅ Create a new tunnel
4. ✅ Generate configuration files:
   - `cloudflare-config-privae.yml`
   - `start-cloudflare-tunnel.sh`
   - `stop-cloudflare-tunnel.sh`

**Take note of the Tunnel ID** shown during setup - you'll need it for the dashboard configuration.

## Step 2: Configure DNS in Cloudflare Dashboard

### 2.1 Access Cloudflare Dashboard

1. Go to: **https://dash.cloudflare.com/**
2. Login with your Cloudflare account
3. Select the **umbrella7.com** domain

### 2.2 Navigate to Tunnel Configuration

1. In the left sidebar, click **Traffic**
2. Click **Cloudflare Tunnel**
3. You should see your newly created tunnel in the list

### 2.3 Add Public Hostname

1. Click **Configure** next to your tunnel
2. Go to the **Public Hostnames** tab
3. Click **Add a public hostname**

### 2.4 Configure Hostname Settings

Enter the following details:

| Field | Value |
|-------|-------|
| **Subdomain** | `privae` |
| **Domain** | `umbrella7.com` |
| **Path** | (leave empty) |
| **Type** | `HTTP` |
| **URL** | `localhost:3026` |

### 2.5 Additional Settings (Optional but Recommended)

Click **Additional application settings** and configure:

**HTTP Settings:**
- ✅ Enable **No TLS Verify** (for local development)
- ✅ Enable **HTTP2 Origin**

**TLS Settings:**
- Keep defaults (Cloudflare handles TLS termination)

### 2.6 Save Configuration

1. Click **Save hostname**
2. Wait for DNS propagation (usually < 1 minute)

## Step 3: Start the Tunnel

```bash
./start-cloudflare-tunnel.sh
```

You should see:
```
🌐 Starting CloudFlare Tunnel for PrivaeChat
==============================================
🚀 Starting tunnel...
⏳ Waiting for tunnel to connect......
✓ Tunnel connected successfully!

🌐 Your PrivaeChat instance is now accessible at:
   https://privae.umbrella7.com
```

## Step 4: Test Access

1. Open browser to: **https://privae.umbrella7.com**
2. You should see the LibreChat interface
3. Register a new account or login

## Verification Checklist

- [ ] Tunnel created successfully
- [ ] DNS configured in Cloudflare dashboard
- [ ] Tunnel started without errors
- [ ] Can access https://privae.umbrella7.com
- [ ] LibreChat UI loads correctly
- [ ] Can register/login
- [ ] Can select Ollama models
- [ ] Can send/receive messages

## Troubleshooting

### Tunnel won't connect

**Check logs:**
```bash
tail -f cloudflare-tunnel.log
```

**Common issues:**
- Firewall blocking outbound connections
- Cloudflared not logged in properly
- Wrong tunnel ID in config

**Solution:**
```bash
# Re-login to Cloudflare
cloudflared tunnel login

# Restart tunnel
./stop-cloudflare-tunnel.sh
./start-cloudflare-tunnel.sh
```

### 502 Bad Gateway

**Causes:**
- LibreChat not running
- Wrong port in dashboard configuration
- Service crashed

**Solutions:**
```bash
# Check if LibreChat is running
curl http://localhost:3026/api/health

# If not running, start services
./start-services.sh

# Check logs
tail -f logs/librechat.log
```

### DNS not resolving

**Wait for propagation:**
- Usually takes < 1 minute
- Can take up to 5 minutes in rare cases

**Check DNS:**
```bash
# Should show Cloudflare IPs
dig privae.umbrella7.com

# Or use nslookup
nslookup privae.umbrella7.com
```

### Permission denied errors

**Fix script permissions:**
```bash
chmod +x start-cloudflare-tunnel.sh
chmod +x stop-cloudflare-tunnel.sh
chmod +x setup-cloudflare.sh
```

## Managing the Tunnel

### Start Tunnel
```bash
./start-cloudflare-tunnel.sh
```

### Stop Tunnel
```bash
./stop-cloudflare-tunnel.sh
```

### Check Tunnel Status
```bash
# View running process
ps aux | grep cloudflared

# Check logs
tail -f cloudflare-tunnel.log
```

### List all tunnels
```bash
cloudflared tunnel list
```

### Delete tunnel (if needed)
```bash
cloudflared tunnel delete <tunnel-name-or-id>
```

## Security Considerations

### Recommended: Add Cloudflare Access

For production, add access policies:

1. In Cloudflare Dashboard go to **Access** → **Applications**
2. Click **Add an application**
3. Select **Self-hosted**
4. Configure:
   - **Application domain:** `privae.umbrella7.com`
   - **Policy name:** "PrivaeChat Access"
   - **Action:** Allow
   - **Rules:** Configure who can access (email, IP, etc.)

### Authentication Options

LibreChat has built-in authentication:
- User registration enabled by default
- Can disable with `ALLOW_REGISTRATION=false` in `.env`
- JWT-based sessions
- Password reset via email (configure SMTP)

## Advanced Configuration

### Custom Tunnel Settings

Edit `cloudflare-config-privae.yml` to customize:

```yaml
ingress:
  - hostname: privae.umbrella7.com
    service: http://localhost:3026
    originRequest:
      noTLSVerify: true
      connectTimeout: 30s
      tlsTimeout: 10s
      keepAliveConnections: 100
```

### Multiple Subdomains

Add additional hostnames in dashboard for different services:
- `privae.umbrella7.com` → LibreChat (port 3026)
- `privae-api.umbrella7.com` → API only
- `privae-admin.umbrella7.com` → Admin panel

## Environment-Specific Settings

### Production

- Set `DOMAIN_CLIENT=https://privae.umbrella7.com` in `.env`
- Set `DOMAIN_SERVER=https://privae.umbrella7.com` in `.env`
- Change JWT secrets in `.env`
- Consider disabling registration after initial users
- Set up monitoring/alerts

### Development

- Keep localhost URLs in `.env`
- Use `--tunnel` flag only when testing external access
- Separate dev/prod tunnels recommended

## Next Steps

After successful setup:

1. **Register your first user:** Go to https://privae.umbrella7.com
2. **Test Ollama integration:** Start a conversation
3. **Try different models:** Switch between deepseek-r1 models
4. **Upload files:** Test file attachment feature
5. **Explore features:** Conversation search, image uploads, etc.

## Support Resources

- **LibreChat Docs:** https://www.librechat.ai/docs
- **Cloudflare Tunnel Docs:** https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/
- **Project README:** See `README.md` in project root
- **Issue Tracker:** https://github.com/yourusername/privae-chat/issues

## Quick Reference

| Component | URL/Command |
|-----------|-------------|
| **Local Access** | http://localhost:3026 |
| **Public Access** | https://privae.umbrella7.com |
| **Dashboard** | https://dash.cloudflare.com/ |
| **Start Tunnel** | `./start-cloudflare-tunnel.sh` |
| **Stop Tunnel** | `./stop-cloudflare-tunnel.sh` |
| **Tunnel Logs** | `tail -f cloudflare-tunnel.log` |
| **Service Logs** | `tail -f logs/librechat.log` |

---

**Configuration complete!** Your PrivaeChat instance is now accessible securely via Cloudflare Tunnel at https://privae.umbrella7.com 🎉
