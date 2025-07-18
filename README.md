# Erdata Monitoring System

A comprehensive hybrid infrastructure monitoring solution that combines n8n workflow automation, SSH-based monitoring, and cloud API integrations to provide real-time insights and alerting across diverse infrastructure environments.

## 🚀 Features

- **Visual Workflow Design**: Leverage n8n's intuitive drag-and-drop interface for creating monitoring workflows
- **Hybrid Infrastructure Support**: Monitor on-premises servers, cloud resources, and hybrid environments
- **Multi-Protocol Monitoring**: SSH, SNMP, HTTP/HTTPS, and cloud API integrations
- **Real-time Alerting**: Multi-channel notifications via email, Slack, SMS, and webhooks
- **Scalable Architecture**: Designed for both single-node and distributed deployments
- **Custom Metrics**: Extensible script-based monitoring for specific requirements
- **Self-Monitoring**: Built-in monitoring of the monitoring system itself
- **Security-First**: Encrypted credentials, secure communication, and audit logging

## 🏗️ Architecture

The system is built on a modular architecture with the following key components:

- **n8n Workflow Engine**: Orchestrates all monitoring activities
- **Metric Collection Scripts**: Custom scripts for specialized monitoring needs
- **Data Processing Pipeline**: Real-time data normalization and analysis
- **Alerting System**: Intelligent alert routing and escalation
- **Configuration Management**: Centralized configuration with environment-specific overrides

For detailed architecture information, see [docs/architecture.md](docs/architecture.md).

## 📁 Directory Structure

```
erdata-monitoring-system/
├── README.md                 # This file - project overview and getting started
├── .gitignore               # Git ignore patterns for Node.js, n8n, and system files
├── docs/                    # Documentation directory
│   └── architecture.md      # System architecture and design documentation
├── n8n-workflows/           # Exported n8n workflow files (.json)
│   └── .gitkeep            # Ensures directory is tracked in git
└── scripts/                 # Custom metric collection and monitoring scripts
    └── .gitkeep            # Ensures directory is tracked in git
```

## 🚦 Getting Started

### Prerequisites

- Docker and Docker Compose
- Git
- (Optional) Node.js 18+ and npm/yarn for local development

### Docker Deployment (Recommended)

The fastest way to get the Erdata Monitoring System running is using Docker:

1. **Clone the repository**
   ```bash
   git clone https://github.com/dexamethazon/erdata-monitoring-system.git
   cd erdata-monitoring-system
   ```

2. **Configure environment variables**
   ```bash
   cp .env.example .env
   # Edit .env file with your configuration
   nano .env
   ```

3. **Deploy using the automated script**
   ```bash
   # Development deployment
   ./deploy.sh

   # Production deployment with database and cache
   ./deploy.sh -e production
   ```

4. **Manual Docker deployment**
   ```bash
   # Basic deployment
   docker-compose up -d

   # With database and cache (recommended for production)
   docker-compose --profile database --profile cache up -d

   # Development mode with live reload
   docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
   ```

5. **Access the system**
   - Open your browser to `http://localhost:5678`
   - Default credentials: `admin/admin` (change in .env file)
   - Import workflows from the `n8n-workflows/` directory

### Local Development Setup

For local development without Docker:

1. **Install n8n** (if not already installed)
   ```bash
   # Via npm
   npm install -g n8n
   
   # Or via Docker
   docker run -it --rm --name n8n -p 5678:5678 n8nio/n8n
   ```

2. **Set up environment variables**
   ```bash
   export N8N_HOST=localhost
   export N8N_PORT=5678
   export N8N_PROTOCOL=http
   ```

3. **Start n8n**
   ```bash
   n8n start
   ```

### Configuration

1. **Environment Setup**
   - Copy example environment files and customize for your environment
   - Configure database connections for metric storage
   - Set up notification channels (email, Slack, etc.)

2. **Workflow Import**
   - Import pre-built workflows from `n8n-workflows/`
   - Customize triggers, schedules, and thresholds
   - Configure target systems and credentials

3. **Script Deployment**
   - Deploy monitoring scripts from `scripts/` to appropriate systems
   - Configure SSH keys and access permissions
   - Test script execution and data collection

### Development

1. **Adding New Workflows**
   - Create workflows in n8n interface
   - Export as JSON files to `n8n-workflows/`
   - Document workflow purpose and configuration

2. **Custom Scripts**
   - Add new monitoring scripts to `scripts/`
   - Follow naming conventions: `{target-type}-{metric-name}.{ext}`
   - Include error handling and logging

3. **Documentation**
   - Update architecture documentation for significant changes
   - Maintain README for new features or configuration changes

## 🔧 Configuration

### Docker Environment Variables

The system uses environment variables for configuration. Copy `.env.example` to `.env` and customize:

| Variable | Description | Default |
|----------|-------------|---------|
| `N8N_HOST` | n8n instance hostname | `0.0.0.0` |
| `N8N_PORT` | n8n service port | `5678` |
| `N8N_PROTOCOL` | HTTP/HTTPS protocol | `http` |
| `N8N_BASIC_AUTH_USER` | Basic auth username | `admin` |
| `N8N_BASIC_AUTH_PASSWORD` | Basic auth password | `admin` |
| `WEBHOOK_URL` | Base URL for webhook endpoints | `http://localhost:5678/webhook` |
| `DB_TYPE` | Database type (optional) | `postgresdb` |
| `GENERIC_TIMEZONE` | System timezone | `UTC` |

### Docker Deployment Options

#### Basic Deployment
```bash
docker-compose up -d
```

#### Production Deployment with Database
```bash
docker-compose --profile database --profile cache up -d
```

#### Development Mode
```bash
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```

### Legacy Environment Variables

For direct n8n installations without Docker:

| Variable | Description | Default |
|----------|-------------|---------|
| `N8N_HOST` | n8n instance hostname | `localhost` |
| `N8N_PORT` | n8n service port | `5678` |
| `N8N_PROTOCOL` | HTTP/HTTPS protocol | `http` |
| `WEBHOOK_URL` | Base URL for webhook endpoints | `http://localhost:5678/webhook` |
| `DB_CONNECTION` | Database connection string | - |

### Monitoring Targets

- **Linux/Unix Servers**: SSH-based system monitoring
- **Windows Servers**: WMI and PowerShell-based monitoring
- **Cloud Resources**: AWS CloudWatch, Azure Monitor, GCP Monitoring
- **Network Devices**: SNMP-based monitoring
- **Databases**: MySQL, PostgreSQL, MongoDB health checks
- **Applications**: Custom HTTP/API endpoint monitoring

## 🔒 Security

- **Credential Management**: Encrypted storage of SSH keys and API credentials
- **Network Security**: Configurable firewall rules and access controls
- **Audit Logging**: Comprehensive logging of all monitoring activities
- **Data Encryption**: Encryption at rest and in transit
- **Access Control**: Role-based access control for workflow management

## 📊 Monitoring Capabilities

- **System Metrics**: CPU, memory, disk, network utilization
- **Application Metrics**: Response times, error rates, throughput
- **Business Metrics**: Custom KPIs and business-specific measurements
- **Infrastructure Health**: Service availability and dependency monitoring
- **Performance Trends**: Historical analysis and capacity planning

## 🚨 Alerting

- **Multi-Channel Notifications**: Email, Slack, SMS, webhooks
- **Intelligent Routing**: Route alerts based on severity and team responsibility
- **Escalation Policies**: Automatic escalation for unacknowledged alerts
- **Alert Correlation**: Reduce noise through intelligent alert grouping
- **Custom Templates**: Flexible alert message formatting

## 🐳 Docker Management

### Useful Docker Commands

```bash
# View logs
docker-compose logs -f

# Stop all services
docker-compose down

# Stop and remove volumes (WARNING: data loss)
docker-compose down -v

# Rebuild containers
docker-compose build

# Update to latest images
docker-compose pull && docker-compose up -d

# Access n8n shell
docker-compose exec erdata-monitoring bash

# View container status
docker-compose ps

# Monitor resource usage
docker stats
```

### Docker Profiles

The system supports different deployment profiles:

- **default**: Just the n8n monitoring system
- **database**: Includes PostgreSQL for data persistence
- **cache**: Includes Redis for caching and queues

Use profiles with: `docker-compose --profile database --profile cache up -d`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Related Resources

- [n8n Documentation](https://docs.n8n.io/)
- [System Architecture](docs/architecture.md)
- [Workflow Examples](n8n-workflows/)
- [Monitoring Scripts](scripts/)

## 📞 Support

For support and questions:
- Create an issue in this repository
- Check the documentation in the `docs/` directory
- Review existing workflows for examples
