#!/bin/bash

# Test counter
PASSED=0
FAILED=0

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Function to run a test
run_test() {
    local test_name=$1
    local test_command=$2
    local expected_exit_code=${3:-0}

    echo "Running test: $test_name"
    eval "$test_command"
    local exit_code=$?

    if [ $exit_code -eq $expected_exit_code ]; then
        echo -e "${GREEN}✓ Test passed: $test_name${NC}"
        ((PASSED++))
    else
        echo -e "${RED}✗ Test failed: $test_name (exit code: $exit_code)${NC}"
        ((FAILED++))
    fi
    echo "----------------------------------------"
}

# Test password generation
test_password_generation() {
    echo "Testing password generation..."
    
    # Test password length
    run_test "Password length" "generate_password | wc -c | grep -q '^33$'"
    
    # Test password uniqueness
    local pass1=$(generate_password)
    local pass2=$(generate_password)
    run_test "Password uniqueness" "[ \"$pass1\" != \"$pass2\" ]"
    
    # Test password complexity
    run_test "Password complexity" "generate_password | grep -q '[A-Z]' && generate_password | grep -q '[a-z]' && generate_password | grep -q '[0-9]' && generate_password | grep -q '[^A-Za-z0-9]'"
}

# Test Kubernetes secrets
test_k8s_secrets() {
    echo "Testing Kubernetes secrets..."
    
    # Mock kubectl
    kubectl() {
        case "$1" in
            "get")
                echo "secret1 secret2"
                ;;
            "create")
                return 0
                ;;
            "delete")
                return 0
                ;;
            *)
                return 1
                ;;
        esac
    }
    export -f kubectl
    
    # Test secret creation
    run_test "K8s secret creation" "create_k8s_secrets"
    
    # Test secret rotation
    run_test "K8s secret rotation" "rotate_k8s_secrets"
    
    # Test backup creation
    run_test "K8s backup creation" "[ -d k8s/secrets/backup ]"
}

# Test AWS secrets
test_aws_secrets() {
    echo "Testing AWS secrets..."
    
    # Mock AWS CLI
    aws() {
        case "$2" in
            "secretsmanager")
                return 0
                ;;
            "ecs")
                return 0
                ;;
            *)
                return 1
                ;;
        esac
    }
    export -f aws
    
    # Test secret creation
    run_test "AWS secret creation" "create_aws_secrets"
    
    # Test secret rotation
    run_test "AWS secret rotation" "rotate_aws_secrets"
}

# Test Azure secrets
test_azure_secrets() {
    echo "Testing Azure secrets..."
    
    # Mock Azure CLI
    az() {
        case "$2" in
            "keyvault")
                return 0
                ;;
            "webapp")
                return 0
                ;;
            *)
                return 1
                ;;
        esac
    }
    export -f az
    
    # Test secret creation
    run_test "Azure secret creation" "create_azure_secrets"
    
    # Test secret rotation
    run_test "Azure secret rotation" "rotate_azure_secrets"
}

# Test GCP secrets
test_gcp_secrets() {
    echo "Testing GCP secrets..."
    
    # Mock gcloud CLI
    gcloud() {
        case "$2" in
            "secrets")
                return 0
                ;;
            "run")
                return 0
                ;;
            *)
                return 1
                ;;
        esac
    }
    export -f gcloud
    
    # Test secret creation
    run_test "GCP secret creation" "create_gcp_secrets"
    
    # Test secret rotation
    run_test "GCP secret rotation" "rotate_gcp_secrets"
}

# Test secret rotation
test_secret_rotation() {
    echo "Testing secret rotation..."
    
    # Test rotation across all platforms
    run_test "Multi-platform rotation" "rotate_secrets all"
    
    # Test rotation for specific platform
    run_test "Single platform rotation" "rotate_secrets k8s"
}

# Test security measures
test_security_measures() {
    echo "Testing security measures..."
    
    # Test SSL verification
    run_test "SSL verification" "curl -s -o /dev/null -w '%{http_code}' https://example.com | grep -q '200'"
    
    # Test password complexity
    run_test "Password complexity" "generate_password | grep -q '[A-Z]' && generate_password | grep -q '[a-z]' && generate_password | grep -q '[0-9]' && generate_password | grep -q '[^A-Za-z0-9]'"
    
    # Test backup creation
    run_test "Backup creation" "rotate_secrets k8s && [ -d k8s/secrets/backup ]"
    
    # Test audit logging
    run_test "Audit logging" "rotate_secrets k8s && [ -f k8s/secrets/audit.log ]"
    
    # Test encryption
    run_test "Secret encryption" "kubectl get secret test-secret -o jsonpath='{.data}' | grep -q 'encrypted'"
    
    # Test access control
    run_test "Access control" "kubectl auth can-i get secrets --all-namespaces | grep -q 'yes'"
}

# Test validation
test_validation() {
    echo "Testing validation..."
    
    # Test environment variables
    run_test "Environment validation" "[ -n \"$NEW_RELIC_LICENSE_KEY\" ] && [ -n \"$DD_API_KEY\" ]"
    
    # Test directory structure
    run_test "Directory structure" "[ -d k8s/secrets ] && [ -d k8s/secrets/backup ]"
    
    # Test file permissions
    run_test "File permissions" "ls -l k8s/secrets | grep -q '^-rw-------'"
    
    # Test backup integrity
    run_test "Backup integrity" "rotate_secrets k8s && [ -s k8s/secrets/backup/*.yaml ]"
}

# Test error handling
test_error_handling() {
    echo "Testing error handling..."
    
    # Test invalid platform
    run_test "Invalid platform" "rotate_secrets invalid" 1
    
    # Test missing environment variables
    local old_key=$NEW_RELIC_LICENSE_KEY
    unset NEW_RELIC_LICENSE_KEY
    run_test "Missing environment variables" "rotate_secrets k8s" 1
    export NEW_RELIC_LICENSE_KEY=$old_key
    
    # Test network failure
    run_test "Network failure" "curl -s -o /dev/null -w '%{http_code}' https://nonexistent.example.com | grep -q '000'"
    
    # Test permission denied
    run_test "Permission denied" "chmod 000 k8s/secrets && rotate_secrets k8s" 1
    chmod 755 k8s/secrets
}

# Run all tests
echo "Starting test suite..."
echo "----------------------------------------"

test_password_generation
test_k8s_secrets
test_aws_secrets
test_azure_secrets
test_gcp_secrets
test_secret_rotation
test_security_measures
test_validation
test_error_handling

# Print summary
echo "Test Summary:"
echo "----------------------------------------"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo "Total: $((PASSED + FAILED))"

# Exit with appropriate status
if [ $FAILED -eq 0 ]; then
    exit 0
else
    exit 1
fi 