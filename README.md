# ERData Monitoring System

A hybrid infrastructure monitoring solution that combines the power of n8n workflow automation with SSH-based metric collection and cloud API integrations. This system provides comprehensive monitoring capabilities for both on-premises and cloud infrastructure.

## Features

- **Hybrid Monitoring**: Monitor both on-premises servers via SSH and cloud resources via APIs
- **n8n Workflow Automation**: Visual workflow builder for creating complex monitoring scenarios
- **Real-time Alerts**: Configurable alerting through multiple channels (email, Slack, webhooks)
- **Custom Metrics Collection**: SSH-based scripts for collecting system metrics from remote servers
- **Cloud Integration**: Built-in support for major cloud providers (AWS, GCP, Azure)
- **Data Visualization**: Integration with popular visualization tools
- **Scalable Architecture**: Designed to handle monitoring at scale

## Getting Started

### Prerequisites

- Node.js (v16 or higher)
- n8n workflow automation tool
- SSH access to target servers (for on-premises monitoring)
- Cloud provider credentials (for cloud monitoring)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/dexamethazon/erdata-monitoring-system.git
   cd erdata-monitoring-system
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Configure environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. Start n8n:
   ```bash
   npm run n8n
   ```

5. Import the monitoring workflows from the `n8n-workflows/` directory

### Quick Setup

Detailed setup instructions can be found in the [documentation](docs/architecture.md).

## Directory Structure

```
erdata-monitoring-system/
├── README.md                 # Project overview and getting started guide
├── .gitignore               # Git ignore patterns for Node.js, n8n, and monitoring data
├── n8n-workflows/           # n8n workflow export files
│   ├── server-monitoring.json
│   ├── cloud-monitoring.json
│   └── alerting-workflows.json
├── scripts/                 # SSH-based metric collection scripts
│   ├── system-metrics.sh
│   ├── application-health.sh
│   └── network-monitoring.sh
├── docs/                    # Documentation
│   ├── architecture.md      # System architecture and design
│   ├── configuration.md     # Configuration guide
│   └── workflows.md         # Workflow documentation
├── config/                  # Configuration files
│   ├── default.json
│   └── production.json.example
└── package.json             # Node.js dependencies and scripts
```

## Usage

### Basic Monitoring Setup

1. **Configure SSH Access**: Set up SSH keys for target servers
2. **Import Workflows**: Import pre-built workflows from `n8n-workflows/`
3. **Configure Alerts**: Set up notification channels
4. **Deploy Scripts**: Deploy monitoring scripts to target servers
5. **Start Monitoring**: Activate workflows in n8n

### Custom Workflows

Create custom monitoring workflows using n8n's visual interface:
- Combine multiple data sources
- Set up complex alerting logic
- Integrate with external services
- Schedule regular monitoring tasks

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support and questions:
- Create an [issue](https://github.com/dexamethazon/erdata-monitoring-system/issues)
- Check the [documentation](docs/)
- Review existing [workflows](n8n-workflows/)

## Roadmap

- [ ] Advanced machine learning-based anomaly detection
- [ ] Kubernetes monitoring integration
- [ ] Enhanced dashboard capabilities
- [ ] Mobile alert notifications
- [ ] Multi-tenant support
