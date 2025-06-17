# Environment Setup Guide

This guide explains how to set up the environment variables for the Privacy Pal monitoring infrastructure.

## Prerequisites

- OpenSSL (for password generation)
- kubectl (for Kubernetes deployment)
- AWS CLI (for AWS deployment)
- Azure CLI (for Azure deployment)
- Google Cloud SDK (for GCP deployment)
- Required API keys:
  - New Relic License Key
  - Datadog API Key

## Setup Options

### 1. Local Development

To set up environment variables for local development:

```bash
# Set required API keys
export NEW_RELIC_LICENSE_KEY="your-new-relic-key"
export DD_API_KEY="your-datadog-key"
export ALERT_EMAIL="your-email@domain.com"
export SLACK_WEBHOOK_URL="your-slack-webhook-url"

# Run the setup script
./scripts/setup-env.sh local
```

This will create a `.env` file in your project root.

### 2. Kubernetes Deployment

To set up secrets in Kubernetes:

```bash
# Set required API keys
export NEW_RELIC_LICENSE_KEY="your-new-relic-key"
export DD_API_KEY="your-datadog-key"

# Run the setup script
./scripts/setup-env.sh k8s

# Apply the generated secrets
kubectl apply -f k8s/monitoring-secrets.yaml
```

### 3. AWS Deployment

To set up secrets in AWS Secrets Manager:

```bash
# Set required API keys
export NEW_RELIC_LICENSE_KEY="your-new-relic-key"
export DD_API_KEY="your-datadog-key"

# Run the setup script
./scripts/setup-env.sh aws
```

### 4. Azure Deployment

To set up secrets in Azure Key Vault:

```bash
# Set required variables
export NEW_RELIC_LICENSE_KEY="your-new-relic-key"
export DD_API_KEY="your-datadog-key"
export AZURE_RESOURCE_GROUP="your-resource-group"
export AZURE_LOCATION="your-location"

# Run the setup script
./scripts/setup-env.sh azure
```

### 5. GCP Deployment

To set up secrets in Google Cloud Secret Manager:

```bash
# Set required variables
export NEW_RELIC_LICENSE_KEY="your-new-relic-key"
export DD_API_KEY="your-datadog-key"
export GCP_REGION="your-region"

# Run the setup script
./scripts/setup-env.sh gcp
```

## Secret Rotation

The project includes a script for rotating secrets across all supported platforms. To rotate secrets:

```bash
# For local development
./scripts/rotate-secrets.sh local

# For Kubernetes
./scripts/rotate-secrets.sh k8s

# For AWS
./scripts/rotate-secrets.sh aws

# For Azure
./scripts/rotate-secrets.sh azure

# For GCP
./scripts/rotate-secrets.sh gcp
```

The rotation script:
1. Creates new versions of secrets
2. Updates applications to use new secrets
3. Maintains backup of old secrets
4. Handles platform-specific deployment updates

## Security Considerations

1. **Password Generation**
   - The setup script generates secure random passwords
   - Passwords are 24 characters long
   - Uses OpenSSL for cryptographically secure random generation

2. **Secret Management**
   - Never commit actual secrets to version control
   - Use the provided template files for structure
   - Rotate secrets regularly (recommended every 90 days)
   - Use different secrets for different environments

3. **Access Control**
   - Implement least privilege access
   - Use service accounts with minimal required permissions
   - Enable audit logging for secret access

## Environment Variables

### Required Variables
- `NEW_RELIC_LICENSE_KEY`: Your New Relic license key
- `DD_API_KEY`: Your Datadog API key

### Platform-Specific Variables
- AWS: None additional required
- Azure: `AZURE_RESOURCE_GROUP`, `AZURE_LOCATION`
- GCP: `GCP_REGION`

### Optional Variables
- `ALERT_EMAIL`: Email for alert notifications
- `SLACK_WEBHOOK_URL`: Slack webhook URL for notifications

### Generated Variables
The following variables are automatically generated:
- `ES_PASSWORD`: Elasticsearch password
- `KIBANA_PASSWORD`: Kibana password

## Troubleshooting

1. **Script Execution Issues**
   - Ensure the script has execute permissions: `chmod +x scripts/setup-env.sh`
   - Verify OpenSSL is installed
   - Check required environment variables are set

2. **Platform-Specific Issues**
   - Kubernetes:
     - Verify kubectl is configured correctly
     - Check namespace exists: `kubectl get namespace monitoring`
     - Verify secret creation: `kubectl get secrets -n monitoring`
   - AWS:
     - Verify AWS CLI is configured
     - Check IAM permissions for Secrets Manager
     - Verify secret creation in AWS Console
   - Azure:
     - Verify Azure CLI is logged in
     - Check Key Vault permissions
     - Verify resource group exists
   - GCP:
     - Verify gcloud is configured
     - Check Secret Manager permissions
     - Verify project and region settings

## Maintenance

1. **Regular Tasks**
   - Rotate passwords every 90 days
   - Review access logs
   - Update API keys when needed
   - Verify backup procedures

2. **Monitoring**
   - Check secret access patterns
   - Monitor for unauthorized access attempts
   - Review audit logs regularly
   - Verify secret rotation success

## Support

For issues or questions:
1. Check the troubleshooting section
2. Review the logs
3. Contact the DevOps team 