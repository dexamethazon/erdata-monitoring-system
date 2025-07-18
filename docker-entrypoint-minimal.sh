#!/bin/bash
set -e

echo "Initializing Erdata Monitoring System..."

# Initialize application data if needed
if [ ! -f "/home/node/.n8n/.initialized" ]; then
    echo "First-time setup detected. Initializing n8n data directory..."
    
    # Create necessary directories
    mkdir -p /home/node/.n8n/workflows
    
    # Copy default workflows if they exist
    if [ -d "/app/workflows" ] && [ "$(ls -A /app/workflows)" ]; then
        echo "Copying default workflows..."
        cp -r /app/workflows/* /home/node/.n8n/workflows/ 2>/dev/null || true
    fi
    
    # Mark as initialized
    touch /home/node/.n8n/.initialized
    echo "Initialization complete."
fi

echo "Starting n8n monitoring system..."
echo "n8n will be available at: ${N8N_PROTOCOL:-http}://${N8N_HOST:-localhost}:${N8N_PORT:-5678}"

# Start n8n with original entrypoint
exec /usr/local/bin/docker-entrypoint.sh n8n start