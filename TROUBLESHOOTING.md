# PrivaeChat Troubleshooting Guide

## Issue: Empty Model Dropdown / No Endpoints Loading

### Symptoms
- Login successful but no models appear in dropdown
- `/api/endpoints` returns empty `{}`
- "Custom config file loaded" doesn't appear in logs
- Log shows "Outdated Config version: undefined"

### Root Cause
**Stale Redis cache.** LibreChat caches endpoint configurations in Redis with no TTL (Time To Live). If the config fails validation at any point, an empty configuration gets cached and persists even after fixing the config files.

### Solution
Clear the Redis cache:

```bash
# Option 1: Flush all Redis data
docker exec privae_redis redis-cli FLUSHALL

# Option 2: Flush only the current database
docker exec privae_redis redis-cli FLUSHDB

# Option 3: Delete specific cache keys
docker exec privae_redis redis-cli DEL "CONFIG_STORE:ENDPOINT_CONFIG" "CONFIG_STORE:_BASE_"
```

Then restart LibreChat:
```bash
./stop-services.sh
./start-services.sh
```

### Verification
Check that the config loaded successfully:
```bash
# Should show "Custom config file loaded:"
grep "Custom config file loaded" logs/librechat-backend.log

# Should return endpoint configuration (not empty {})
curl -s http://localhost:3026/api/endpoints
```

## Issue: Config Changes Not Taking Effect

### Cause
Redis is caching the old configuration.

### Solution
Always clear Redis cache after modifying `librechat.yaml` or `.env`:
```bash
docker exec privae_redis redis-cli FLUSHDB
./stop-services.sh
./start-services.sh
```

## Issue: Precompiled Packages vs Source

### Problem
Using precompiled packages can lead to unexpected behavior.

### Solution
Always rebuild packages from source when troubleshooting:
```bash
cd /home/mbc/dev/LibreChat
npm run build:packages
npm run build:data-provider
```

## Best Practices

1. **Validate config before starting**
   ```bash
   cd /home/mbc/dev/LibreChat
   node -e "const yaml = require('js-yaml'); const fs = require('fs'); console.log(yaml.load(fs.readFileSync('librechat.yaml', 'utf8')));"
   ```

2. **Monitor startup logs**
   ```bash
   tail -f logs/librechat-backend.log
   ```
   Look for "Custom config file loaded:" to confirm config is loading.

3. **Clear cache when changing config**
   Make it a habit to flush Redis after any configuration changes.

4. **Use version control**
   Commit working configurations so you can revert if needed.

## Common Configuration Issues

### ENDPOINTS Environment Variable
The `ENDPOINTS` variable must match what's in your `librechat.yaml`:
- If using `endpoints.custom` in YAML: `ENDPOINTS=custom`
- Multiple endpoints: `ENDPOINTS=openAI,custom`

### CONFIG_PATH
If set, must be an absolute path:
```bash
CONFIG_PATH=/home/mbc/dev/LibreChat/librechat.yaml  # ✓ Correct
CONFIG_PATH=librechat.yaml                           # ✗ Wrong
```

Or omit it entirely to use the default location (LibreChat root directory).

### librechat.yaml Validation
Common syntax errors:
- Incorrect indentation (YAML is whitespace-sensitive)
- Missing quotes around URLs or special characters
- Array vs object confusion (especially in fileConfig.endpoints)

## Debug Commands

```bash
# Check if LibreChat is running
lsof -i :3026

# View real-time logs
tail -f logs/librechat-backend.log

# Test Ollama connectivity
curl http://localhost:11434/v1/models

# Check Redis keys
docker exec privae_redis redis-cli KEYS "*"

# View cached endpoint config
docker exec privae_redis redis-cli GET "CONFIG_STORE:ENDPOINT_CONFIG"

# Check environment variables
cat /home/mbc/dev/LibreChat/.env | grep -E "^(ENDPOINTS|CONFIG_PATH)="
```

## Emergency Recovery

If nothing works:
```bash
# 1. Stop everything
./stop-services.sh

# 2. Clear all caches
docker exec privae_redis redis-cli FLUSHALL

# 3. Rebuild packages
cd /home/mbc/dev/LibreChat
npm run build:packages

# 4. Restart
cd /home/mbc/dev/privae-chat
./start-services.sh
```
