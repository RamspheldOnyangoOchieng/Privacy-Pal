#!/bin/bash

# Function to generate a secure random password
generate_password() {
    openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 24
}

# Function to create Kubernetes secrets
create_k8s_secrets() {
    echo "Creating Kubernetes secrets..."
    kubectl create secret generic monitoring-secrets \
        --from-literal=ES_USER=elastic \
        --from-literal=ES_PASSWORD=$(generate_password) \
        --from-literal=KIBANA_USER=kibana \
        --from-literal=KIBANA_PASSWORD=$(generate_password) \
        --from-literal=NEW_RELIC_LICENSE_KEY=$NEW_RELIC_LICENSE_KEY \
        --from-literal=DD_API_KEY=$DD_API_KEY \
        --dry-run=client -o yaml > k8s/monitoring-secrets.yaml
}

# Function to create AWS secrets
create_aws_secrets() {
    echo "Creating AWS secrets..."
    aws secretsmanager create-secret \
        --name /privacy-pal/monitoring \
        --secret-string "{
            \"ES_USER\": \"elastic\",
            \"ES_PASSWORD\": \"$(generate_password)\",
            \"KIBANA_USER\": \"kibana\",
            \"KIBANA_PASSWORD\": \"$(generate_password)\",
            \"NEW_RELIC_LICENSE_KEY\": \"$NEW_RELIC_LICENSE_KEY\",
            \"DD_API_KEY\": \"$DD_API_KEY\"
        }"
}

# Function to create Azure secrets
create_azure_secrets() {
    echo "Creating Azure Key Vault secrets..."
    # Create Key Vault if it doesn't exist
    az keyvault create --name privacy-pal-vault --resource-group $AZURE_RESOURCE_GROUP --location $AZURE_LOCATION

    # Store secrets in Key Vault
    az keyvault secret set --vault-name privacy-pal-vault --name "ES-USER" --value "elastic"
    az keyvault secret set --vault-name privacy-pal-vault --name "ES-PASSWORD" --value "$(generate_password)"
    az keyvault secret set --vault-name privacy-pal-vault --name "KIBANA-USER" --value "kibana"
    az keyvault secret set --vault-name privacy-pal-vault --name "KIBANA-PASSWORD" --value "$(generate_password)"
    az keyvault secret set --vault-name privacy-pal-vault --name "NEW-RELIC-LICENSE-KEY" --value "$NEW_RELIC_LICENSE_KEY"
    az keyvault secret set --vault-name privacy-pal-vault --name "DD-API-KEY" --value "$DD_API_KEY"
}

# Function to create GCP secrets
create_gcp_secrets() {
    echo "Creating GCP Secret Manager secrets..."
    # Create secrets in Secret Manager
    echo -n "elastic" | gcloud secrets create es-user --data-file=-
    echo -n "$(generate_password)" | gcloud secrets create es-password --data-file=-
    echo -n "kibana" | gcloud secrets create kibana-user --data-file=-
    echo -n "$(generate_password)" | gcloud secrets create kibana-password --data-file=-
    echo -n "$NEW_RELIC_LICENSE_KEY" | gcloud secrets create new-relic-license-key --data-file=-
    echo -n "$DD_API_KEY" | gcloud secrets create dd-api-key --data-file=-
}

# Function to create local .env file
create_local_env() {
    echo "Creating local .env file..."
    cat > .env << EOL
# Elasticsearch Configuration
ES_USER=elastic
ES_PASSWORD=$(generate_password)

# Kibana Configuration
KIBANA_USER=kibana
KIBANA_PASSWORD=$(generate_password)

# Environment Configuration
ENVIRONMENT=development

# New Relic Configuration
NEW_RELIC_LICENSE_KEY=$NEW_RELIC_LICENSE_KEY

# Datadog Configuration
DD_API_KEY=$DD_API_KEY

# Additional Security Settings
ELASTICSEARCH_SSL_VERIFICATION=true
KIBANA_SSL_VERIFICATION=true
LOGSTASH_SSL_VERIFICATION=true

# Service Ports
ELASTICSEARCH_PORT=9200
KIBANA_PORT=5601
LOGSTASH_PORT=5044
PROMETHEUS_PORT=9090
JAEGER_PORT=16686

# Retention Settings
ELASTICSEARCH_RETENTION_DAYS=30
PROMETHEUS_RETENTION_DAYS=15
JAEGER_RETENTION_DAYS=7

# Monitoring Settings
ENABLE_APM=true
ENABLE_LOGGING=true
ENABLE_METRICS=true
ENABLE_TRACING=true

# Alert Settings
ALERT_EMAIL=$ALERT_EMAIL
SLACK_WEBHOOK_URL=$SLACK_WEBHOOK_URL
EOL
}

# Main script
echo "Setting up environment variables..."

# Check for required environment variables
if [ -z "$NEW_RELIC_LICENSE_KEY" ] || [ -z "$DD_API_KEY" ]; then
    echo "Error: NEW_RELIC_LICENSE_KEY and DD_API_KEY must be set"
    exit 1
fi

# Create necessary directories
mkdir -p k8s

# Create secrets based on platform
case "$1" in
    "k8s")
        create_k8s_secrets
        ;;
    "aws")
        create_aws_secrets
        ;;
    "azure")
        if [ -z "$AZURE_RESOURCE_GROUP" ] || [ -z "$AZURE_LOCATION" ]; then
            echo "Error: AZURE_RESOURCE_GROUP and AZURE_LOCATION must be set for Azure deployment"
            exit 1
        fi
        create_azure_secrets
        ;;
    "gcp")
        create_gcp_secrets
        ;;
    "local")
        create_local_env
        ;;
    *)
        echo "Usage: $0 {k8s|aws|azure|gcp|local}"
        exit 1
        ;;
esac

echo "Environment setup complete!" 