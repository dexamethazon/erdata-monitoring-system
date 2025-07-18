#!/bin/bash

# Basic server health check script for the Erdata Monitoring System
# This script performs basic system health checks and outputs JSON

set -e

# Get current timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Get system uptime
UPTIME=$(uptime -p 2>/dev/null || echo "unknown")

# Get load average
LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | tr -d ' ')

# Get memory usage (if available)
if command -v free >/dev/null 2>&1; then
    MEMORY_TOTAL=$(free -m | awk 'NR==2{print $2}')
    MEMORY_USED=$(free -m | awk 'NR==2{print $3}')
    MEMORY_PERCENT=$(awk "BEGIN {printf \"%.1f\", ($MEMORY_USED/$MEMORY_TOTAL)*100}")
else
    MEMORY_TOTAL="unknown"
    MEMORY_USED="unknown"
    MEMORY_PERCENT="unknown"
fi

# Get disk usage for root partition
if command -v df >/dev/null 2>&1; then
    DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
else
    DISK_USAGE="unknown"
fi

# Output JSON
cat << EOF
{
  "timestamp": "$TIMESTAMP",
  "status": "healthy",
  "metrics": {
    "uptime": "$UPTIME",
    "load_average": "$LOAD_AVG",
    "memory": {
      "total_mb": $MEMORY_TOTAL,
      "used_mb": $MEMORY_USED,
      "usage_percent": $MEMORY_PERCENT
    },
    "disk": {
      "usage_percent": $DISK_USAGE
    }
  }
}
EOF