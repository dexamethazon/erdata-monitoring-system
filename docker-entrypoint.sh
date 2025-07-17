#!/bin/bash
set -e

# Initialize n8n data directory if it doesn't exist
if [ ! -f "/app/data/.initialized" ]; then
    echo "Initializing n8n data directory..."
    
    # Create necessary subdirectories
    mkdir -p /app/data/.n8n
    mkdir -p /app/data/workflows
    mkdir -p /app/data/credentials
    
    # Copy default workflows if they exist
    if [ -d "/app/workflows" ] && [ "$(ls -A /app/workflows)" ]; then
        echo "Copying default workflows..."
        cp -r /app/workflows/* /app/data/workflows/
    fi
    
    # Mark as initialized
    touch /app/data/.initialized
    echo "Initialization complete."
fi

# Set proper permissions
chown -R node:node /app/data
chown -R node:node /app/logs

echo "Starting n8n monitoring system..."
echo "n8n will be available at: ${N8N_PROTOCOL}://${N8N_HOST}:${N8N_PORT}"

# Start n8n
exec su-exec node n8n start