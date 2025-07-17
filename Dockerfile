# Multi-stage build for optimized image
FROM node:18-alpine AS base

# Install n8n globally
RUN npm install -g n8n@latest

# Runtime stage
FROM node:18-alpine AS runtime

# Copy n8n from build stage
COPY --from=base /usr/local/lib/node_modules/n8n /usr/local/lib/node_modules/n8n
COPY --from=base /usr/local/bin/n8n /usr/local/bin/n8n

# Install additional tools for monitoring scripts
RUN apk add --no-cache \
    openssh-client \
    curl \
    bash \
    jq \
    python3 \
    py3-pip \
    su-exec

# Set working directory
WORKDIR /app

# Create necessary directories
RUN mkdir -p /app/workflows /app/scripts /app/data /app/logs

# Copy application files
COPY n8n-workflows/ /app/workflows/
COPY scripts/ /app/scripts/
COPY docs/ /app/docs/

# Set up n8n data directory
ENV N8N_USER_FOLDER=/app/data

# Create startup script
COPY docker-entrypoint.sh /app/docker-entrypoint.sh
RUN chmod +x /app/docker-entrypoint.sh

# Create node user and set permissions
RUN addgroup -g 1001 -S node && \
    adduser -S -D -H -u 1001 -h /app -s /sbin/nologin -G node -g node node

# Set proper ownership
RUN chown -R node:node /app

# Expose n8n port
EXPOSE 5678

# Default environment variables
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=http
ENV WEBHOOK_URL=http://localhost:5678/webhook
ENV N8N_BASIC_AUTH_ACTIVE=true
ENV N8N_BASIC_AUTH_USER=admin
ENV N8N_BASIC_AUTH_PASSWORD=admin

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:5678/healthz || exit 1

# Use startup script as entrypoint
ENTRYPOINT ["/app/docker-entrypoint.sh"]