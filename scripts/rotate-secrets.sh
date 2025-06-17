#!/bin/bash

# Function to generate a secure random password
generate_password() {
    openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 24
}

# Function to rotate Kubernetes secrets
rotate_k8s_secrets() {
    echo "Rotating Kubernetes secrets..."
    # Get current secrets
    kubectl get secret monitoring-secrets -n monitoring -o yaml > k8s/monitoring-secrets-backup.yaml

    # Create new secrets
    kubectl create secret generic monitoring-secrets-new \
        --from-literal=ES_USER=elastic \
        --from-literal=ES_PASSWORD=$(generate_password) \
        --from-literal=KIBANA_USER=kibana \
        --from-literal=KIBANA_PASSWORD=$(generate_password) \
        --from-literal=NEW_RELIC_LICENSE_KEY=$NEW_RELIC_LICENSE_KEY \
        --from-literal=DD_API_KEY=$DD_API_KEY \
        --dry-run=client -o yaml > k8s/monitoring-secrets-new.yaml

    # Apply new secrets
    kubectl apply -f k8s/monitoring-secrets-new.yaml

    # Update deployment to use new secrets
    kubectl rollout restart deployment -n monitoring

    # Wait for rollout to complete
    kubectl rollout status deployment -n monitoring

    # Delete old secrets
    kubectl delete secret monitoring-secrets -n monitoring
    mv k8s/monitoring-secrets-new.yaml k8s/monitoring-secrets.yaml
}

# Function to rotate AWS secrets
rotate_aws_secrets() {
    echo "Rotating AWS secrets..."
    # Create new version of the secret
    aws secretsmanager update-secret \
        --secret-id /privacy-pal/monitoring \
        --secret-string "{
            \"ES_USER\": \"elastic\",
            \"ES_PASSWORD\": \"$(generate_password)\",
            \"KIBANA_USER\": \"kibana\",
            \"KIBANA_PASSWORD\": \"$(generate_password)\",
            \"NEW_RELIC_LICENSE_KEY\": \"$NEW_RELIC_LICENSE_KEY\",
            \"DD_API_KEY\": \"$DD_API_KEY\"
        }"

    # Update applications to use new secret version
    aws ecs update-service --cluster privacy-pal --service monitoring --force-new-deployment
}

# Function to rotate Azure secrets
rotate_azure_secrets() {
    echo "Rotating Azure Key Vault secrets..."
    # Create new versions of secrets
    az keyvault secret set --vault-name privacy-pal-vault --name "ES-PASSWORD" --value "$(generate_password)"
    az keyvault secret set --vault-name privacy-pal-vault --name "KIBANA-PASSWORD" --value "$(generate_password)"
    az keyvault secret set --vault-name privacy-pal-vault --name "NEW-RELIC-LICENSE-KEY" --value "$NEW_RELIC_LICENSE_KEY"
    az keyvault secret set --vault-name privacy-pal-vault --name "DD-API-KEY" --value "$DD_API_KEY"

    # Update applications to use new secrets
    az webapp restart --name privacy-pal --resource-group $AZURE_RESOURCE_GROUP
}

# Function to rotate GCP secrets
rotate_gcp_secrets() {
    echo "Rotating GCP Secret Manager secrets..."
    # Create new versions of secrets
    echo -n "$(generate_password)" | gcloud secrets versions add es-password --data-file=-
    echo -n "$(generate_password)" | gcloud secrets versions add kibana-password --data-file=-
    echo -n "$NEW_RELIC_LICENSE_KEY" | gcloud secrets versions add new-relic-license-key --data-file=-
    echo -n "$DD_API_KEY" | gcloud secrets versions add dd-api-key --data-file=-

    # Update applications to use new secrets
    gcloud run services update privacy-pal --region $GCP_REGION --platform managed
}

# Function to rotate local secrets
rotate_local_secrets() {
    echo "Rotating local secrets..."
    # Backup current .env file
    cp .env .env.backup

    # Create new .env file
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
echo "Starting secret rotation..."

# Check for required environment variables
if [ -z "$NEW_RELIC_LICENSE_KEY" ] || [ -z "$DD_API_KEY" ]; then
    echo "Error: NEW_RELIC_LICENSE_KEY and DD_API_KEY must be set"
    exit 1
fi

# Create necessary directories
mkdir -p k8s

# Rotate secrets based on platform
case "$1" in
    "k8s")
        rotate_k8s_secrets
        ;;
    "aws")
        rotate_aws_secrets
        ;;
    "azure")
        if [ -z "$AZURE_RESOURCE_GROUP" ]; then
            echo "Error: AZURE_RESOURCE_GROUP must be set for Azure rotation"
            exit 1
        fi
        rotate_azure_secrets
        ;;
    "gcp")
        if [ -z "$GCP_REGION" ]; then
            echo "Error: GCP_REGION must be set for GCP rotation"
            exit 1
        fi
        rotate_gcp_secrets
        ;;
    "local")
        rotate_local_secrets
        ;;
    *)
        echo "Usage: $0 {k8s|aws|azure|gcp|local}"
        exit 1
        ;;
esac

echo "Secret rotation complete!" 