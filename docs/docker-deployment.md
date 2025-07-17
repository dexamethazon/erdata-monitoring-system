# Docker Deployment Guide

This guide covers deploying the ER Data Monitoring System using Docker and Docker Compose.

## Quick Start

1. **Clone and configure**
   ```bash
   git clone https://github.com/dexamethazon/erdata-monitoring-system.git
   cd erdata-monitoring-system
   cp .env.example .env
   # Edit .env with your configuration
   ```

2. **Deploy with automated script**
   ```bash
   ./deploy.sh
   ```

3. **Access the system**
   - Open http://localhost:5678
   - Login with credentials from .env file (default: admin/admin)

## Manual Deployment

### Basic Deployment
```bash
docker compose up -d
```

### Production Deployment with Database
```bash
docker compose --profile database --profile cache up -d
```

### Development Mode
```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```

## Configuration

### Environment Variables

The system uses environment variables for configuration. Key variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `DOCKERFILE` | Which Dockerfile to use | `Dockerfile.minimal` |
| `N8N_BASIC_AUTH_USER` | Admin username | `admin` |
| `N8N_BASIC_AUTH_PASSWORD` | Admin password | `changeme` |
| `N8N_PORT` | Port for n8n interface | `5678` |

### Docker Profiles

- **default**: Basic n8n monitoring system
- **database**: Adds PostgreSQL for data persistence
- **cache**: Adds Redis for caching and queues

## Container Management

### View logs
```bash
docker compose logs -f
```

### Stop services
```bash
docker compose down
```

### Rebuild containers
```bash
docker compose build
docker compose up -d
```

### Access container shell
```bash
docker compose exec erdata-monitoring bash
```

## Troubleshooting

### Container won't start
- Check logs: `docker compose logs erdata-monitoring`
- Verify port availability: `netstat -tlnp | grep 5678`
- Check disk space: `df -h`

### Can't access web interface
- Verify container is running: `docker compose ps`
- Check port mapping: `docker port erdata-monitoring-system`
- Test health check: `curl http://localhost:5678/healthz`

### Permission issues
- Reset ownership: `docker compose exec erdata-monitoring chown -R node:node /home/node`
- Check volume mounts: `docker compose exec erdata-monitoring ls -la /app`

## Monitoring Script Integration

The system includes sample monitoring scripts in the `scripts/` directory:

- `server-health-check.sh`: Basic system health metrics
- Scripts are mounted as volumes in containers
- Can be executed from n8n workflows using Execute Command nodes

## Data Persistence

- **Workflows**: Stored in Docker volume `erdata_workflows`
- **Logs**: Stored in Docker volume `erdata_logs`
- **Database**: PostgreSQL data in `erdata_postgres_data` (when using database profile)

## Security Considerations

- Change default passwords in `.env` before deployment
- Use environment-specific configuration files
- Consider using Docker secrets for sensitive data in production
- Regular backup of Docker volumes

## Scaling

For larger deployments:
- Use external database (PostgreSQL/MySQL)
- Deploy Redis for session management
- Consider container orchestration (Kubernetes, Docker Swarm)
- Load balance multiple n8n instances