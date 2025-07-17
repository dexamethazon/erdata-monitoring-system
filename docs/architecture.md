# System Architecture

The ERData Monitoring System is designed as a hybrid infrastructure monitoring solution that leverages n8n's workflow automation capabilities to orchestrate monitoring tasks across diverse infrastructure environments.

## High-Level Architecture

### Core Components

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   n8n Server    │    │  SSH Scripts    │    │  Cloud APIs     │
│   (Orchestrator)│◄──►│  (On-premises)  │    │  (Cloud Infra)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │              ┌─────────────────┐              │
         └──────────────►│  Data Storage   │◄─────────────┘
                        │  & Processing   │
                        └─────────────────┘
                                 │
                        ┌─────────────────┐
                        │   Alerting &    │
                        │  Visualization  │
                        └─────────────────┘
```

### Component Details

#### 1. n8n Workflow Engine
- **Purpose**: Central orchestration and workflow management
- **Responsibilities**:
  - Schedule monitoring tasks
  - Coordinate data collection from multiple sources
  - Process and transform monitoring data
  - Trigger alerts based on configurable conditions
  - Manage workflow state and error handling

#### 2. SSH-Based Monitoring Scripts
- **Purpose**: Collect metrics from on-premises servers
- **Capabilities**:
  - System resource monitoring (CPU, memory, disk, network)
  - Application-specific health checks
  - Log file analysis and pattern matching
  - Custom metric collection
  - Secure authenticated access via SSH keys

#### 3. Cloud API Integrations
- **Purpose**: Monitor cloud infrastructure and services
- **Supported Platforms**:
  - AWS CloudWatch, EC2, RDS, S3
  - Google Cloud Monitoring, Compute Engine, Cloud SQL
  - Azure Monitor, Virtual Machines, Storage
  - Custom REST API endpoints

#### 4. Data Processing Pipeline
- **Data Collection**: Aggregate metrics from all sources
- **Data Transformation**: Normalize and standardize metric formats
- **Data Storage**: Time-series data storage for historical analysis
- **Real-time Processing**: Stream processing for immediate alerting

## Workflow Architecture

### Monitoring Workflows

#### Server Health Monitoring
```
[Scheduler] → [SSH Execute] → [Parse Metrics] → [Store Data] → [Check Thresholds] → [Alert if needed]
     ↓              ↓              ↓              ↓              ↓              ↓
  Every 5min    system-metrics.sh  JSON format   InfluxDB     CPU > 80%     Slack/Email
```

#### Cloud Resource Monitoring
```
[Scheduler] → [API Call] → [Transform Data] → [Store Data] → [Anomaly Detection] → [Alert if needed]
     ↓           ↓            ↓               ↓              ↓                   ↓
  Every 10min  CloudWatch   Standardize     Database    ML-based detection   Multi-channel
```

#### Application Health Checks
```
[Scheduler] → [HTTP Check] → [SSH Log Check] → [Aggregate Results] → [Health Score] → [Dashboard Update]
     ↓            ↓              ↓                 ↓                 ↓               ↓
  Every 2min   App endpoint   application-health.sh   Combined status   0-100 score   Real-time UI
```

### Workflow Design Principles

1. **Modularity**: Each workflow handles a specific monitoring aspect
2. **Reusability**: Common components shared across workflows
3. **Error Handling**: Robust error handling and retry mechanisms
4. **Scalability**: Workflows can be parallelized and distributed
5. **Maintainability**: Clear separation of concerns and documentation

## Configuration Management

### Environment Configuration

The system uses a layered configuration approach:

```
Default Config → Environment Config → Runtime Config
     ↓                    ↓                ↓
  default.json      production.json    CLI arguments
```

### Key Configuration Areas

#### SSH Connection Management
```json
{
  "ssh": {
    "keyPath": "/path/to/private/key",
    "username": "monitoring-user",
    "timeout": 30000,
    "servers": [
      {
        "host": "server1.example.com",
        "port": 22,
        "tags": ["production", "web-server"]
      }
    ]
  }
}
```

#### Cloud Provider Configuration
```json
{
  "cloudProviders": {
    "aws": {
      "region": "us-east-1",
      "accessKeyId": "${AWS_ACCESS_KEY_ID}",
      "secretAccessKey": "${AWS_SECRET_ACCESS_KEY}",
      "services": ["ec2", "rds", "cloudwatch"]
    }
  }
}
```

#### Alerting Configuration
```json
{
  "alerting": {
    "channels": {
      "slack": {
        "webhookUrl": "${SLACK_WEBHOOK_URL}",
        "channel": "#monitoring-alerts"
      },
      "email": {
        "smtp": {
          "host": "smtp.example.com",
          "port": 587,
          "secure": false
        },
        "recipients": ["admin@example.com"]
      }
    },
    "rules": {
      "cpu_threshold": 80,
      "memory_threshold": 85,
      "disk_threshold": 90
    }
  }
}
```

## Security Considerations

### Authentication & Authorization
- SSH key-based authentication for server access
- Cloud provider IAM roles with minimal required permissions
- n8n webhook authentication for external integrations
- Encrypted storage of sensitive configuration data

### Network Security
- VPN or private network access for on-premises servers
- API rate limiting and throttling
- Secure transmission of monitoring data (TLS/SSL)
- Network isolation for monitoring infrastructure

### Data Protection
- Encryption at rest for stored metrics
- Secure handling of credentials and API keys
- Regular rotation of access keys and certificates
- Audit logging for security events

## Deployment Architecture

### Single Node Deployment
```
┌─────────────────────────────────────┐
│           Monitoring Node           │
│  ┌─────────┐  ┌─────────┐          │
│  │   n8n   │  │Database │          │
│  │ Server  │  │(SQLite) │          │
│  └─────────┘  └─────────┘          │
│  ┌─────────────────────────────────┐│
│  │       SSH Scripts & APIs        ││
│  └─────────────────────────────────┘│
└─────────────────────────────────────┘
```

### Distributed Deployment
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  n8n Cluster    │    │   Data Layer    │    │  Alert Gateway  │
│                 │    │                 │    │                 │
│ ┌─────┐ ┌─────┐ │    │ ┌─────────────┐ │    │ ┌─────────────┐ │
│ │ n8n │ │ n8n │ │◄──►│ │  InfluxDB   │ │◄──►│ │  Alerting   │ │
│ │  1  │ │  2  │ │    │ │  Cluster    │ │    │ │  Service    │ │
│ └─────┘ └─────┘ │    │ └─────────────┘ │    │ └─────────────┘ │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Performance Considerations

### Monitoring Intervals
- **Critical Systems**: 1-2 minute intervals
- **Standard Servers**: 5 minute intervals
- **Cloud Resources**: 10-15 minute intervals
- **Log Analysis**: Real-time or near real-time

### Data Retention
- **Raw Metrics**: 30 days high resolution
- **Aggregated Data**: 1 year medium resolution
- **Summary Statistics**: 5 years low resolution
- **Alert History**: 2 years full detail

### Scalability Limits
- **SSH Connections**: ~100 concurrent connections per n8n instance
- **API Rate Limits**: Respect cloud provider limits
- **Database Performance**: Index optimization for time-series queries
- **Memory Usage**: Configure appropriate buffer sizes for data processing

## Extensibility

### Adding New Data Sources
1. Create new n8n nodes for custom integrations
2. Implement data transformation workflows
3. Update configuration schema
4. Add monitoring scripts to `scripts/` directory

### Custom Alerting Channels
1. Extend alerting workflow with new notification nodes
2. Add channel configuration to settings
3. Implement error handling and retry logic
4. Test integration thoroughly

### Metric Plugins
1. Develop custom metric collection scripts
2. Standardize output format (JSON recommended)
3. Add scheduling configuration
4. Document plugin interface and usage