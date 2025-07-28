# DevSecOps Pipeline Setup Guide

## Overview

This guide walks you through setting up comprehensive DevSecOps pipelines using GitHub Actions with Azure OIDC authentication. The setup includes:

- **4 Reusable Workflows**: Security scanning, Terraform deployment, container building, and Kubernetes deployment
- **Azure OIDC Authentication**: No more storing secrets in GitHub
- **Multi-Environment Support**: Nonprod, Prod with proper approvals
- **Comprehensive Security Scanning**: Checkov, TFSec, Trivy, Gosec, TruffleHog, Hadolint
- **Infrastructure as Code**: Terraform with remote state management

## Prerequisites

- Azure subscription with appropriate permissions
- GitHub repositories set up
- Azure CLI installed locally
- Terraform CLI installed locally
- Owner/Contributor access to Azure subscription

## Step 1: Azure Setup

### 1.1 Create Azure AD App Registration

```bash
# Login to Azure
az login

# Set your subscription
SUBSCRIPTION_ID="your-subscription-id"
az account set --subscription $SUBSCRIPTION_ID

# Create App Registration
APP_NAME="github-actions-wiz-exercise"
APP_REGISTRATION=$(az ad app create --display-name $APP_NAME --query appId -o tsv)
echo "App Registration ID: $APP_REGISTRATION"

# Create Service Principal
OBJECT_ID=$(az ad sp create --id $APP_REGISTRATION --query id -o tsv)
echo "Service Principal Object ID: $OBJECT_ID"
```

### 1.2 Configure Federated Identity Credentials

For each repository, create federated credentials:

```bash
# Replace with your GitHub organization and repository names
GITHUB_ORG="YOUR_ORG"
GITHUB_REPO="tf-plat-connectivity"  # Repeat for each repo

# Main branch credential
az ad app federated-credential create \
  --id $APP_REGISTRATION \
  --parameters '{
    "name": "'$GITHUB_REPO'-main",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:'$GITHUB_ORG'/'$GITHUB_REPO':ref:refs/heads/main",
    "audiences": ["api://AzureADTokenExchange"]
  }'

# Pull request credential
az ad app federated-credential create \
  --id $APP_REGISTRATION \
  --parameters '{
    "name": "'$GITHUB_REPO'-pr",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:'$GITHUB_ORG'/'$GITHUB_REPO':pull_request",
    "audiences": ["api://AzureADTokenExchange"]
  }'

# Environment-specific credential (for nonprod/prod)
az ad app federated-credential create \
  --id $APP_REGISTRATION \
  --parameters '{
    "name": "'$GITHUB_REPO'-environment",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:'$GITHUB_ORG'/'$GITHUB_REPO':environment:nonprod",
    "audiences": ["api://AzureADTokenExchange"]
  }'
```

**Repeat the above for all repositories:**
- `tf-reusable-workflows`
- `tf-plat-connectivity`  
- `tf-subscription-vending-machine`
- `tf-wizardapp` (when ready)

### 1.3 Assign Azure Permissions

```bash
# Assign Contributor role at subscription level
az role assignment create \
  --assignee $APP_REGISTRATION \
  --role "Contributor" \
  --scope "/subscriptions/$SUBSCRIPTION_ID"

# Assign User Access Administrator for role assignments
az role assignment create \
  --assignee $APP_REGISTRATION \
  --role "User Access Administrator" \
  --scope "/subscriptions/$SUBSCRIPTION_ID"
```

### 1.4 Create Terraform State Storage

```bash
# Create resource group for Terraform state
TERRAFORM_STATE_RG="rg-terraform-state-prod-eastus2-001"
LOCATION="eastus2"

az group create \
  --name $TERRAFORM_STATE_RG \
  --location $LOCATION

# Create storage account for Terraform state
STORAGE_ACCOUNT_NAME="sttfstateprod$(date +%s | cut -c6-10)"  # Ensures uniqueness
az storage account create \
  --name $STORAGE_ACCOUNT_NAME \
  --resource-group $TERRAFORM_STATE_RG \
  --location $LOCATION \
  --sku "Standard_LRS" \
  --encryption-services blob

# Create container for state files
az storage container create \
  --name "tfstate" \
  --account-name $STORAGE_ACCOUNT_NAME

echo "Storage Account: $STORAGE_ACCOUNT_NAME"
```

## Step 2: GitHub Repository Setup

### 2.1 Update Reusable Workflow References

In all workflow files, replace `YOUR_ORG` with your actual GitHub organization:

```bash
# Find and replace in all workflow files
find . -name "*.yml" -exec sed -i 's/YOUR_ORG/your-actual-org/g' {} \;
```

### 2.2 Create GitHub Environments

For each repository, create environments in GitHub:

1. Go to repository → Settings → Environments
2. Create `nonprod` environment:
   - ✅ Required reviewers: Add yourself
   - ✅ Wait timer: 0 minutes
   - ✅ Environment protection rules
3. Create `prod` environment:
   - ✅ Required reviewers: Add 2+ reviewers
   - ✅ Wait timer: 5 minutes
   - ✅ Environment protection rules
   - ✅ Restrict to main branch only

### 2.3 Configure Repository Variables

For each repository, add these **Repository Variables** (Settings → Secrets and variables → Actions → Variables):

```
AZURE_CLIENT_ID=<your-app-registration-id>
AZURE_TENANT_ID=<your-azure-tenant-id>
AZURE_SUBSCRIPTION_ID=<your-subscription-id>
TF_STATE_RESOURCE_GROUP=rg-terraform-state-prod-eastus2-001
TF_STATE_STORAGE_ACCOUNT=<your-storage-account-name>
TF_STATE_CONTAINER=tfstate
```

### 2.4 Configure Repository Settings

For each repository:

1. **Branch Protection Rules** (Settings → Branches):
   - Protect `main` branch
   - ✅ Require pull request reviews before merging
   - ✅ Require status checks to pass before merging
   - ✅ Require up-to-date branches before merging
   - ✅ Include administrators

2. **Security Settings** (Settings → Security):
   - ✅ Enable Dependency graph
   - ✅ Enable Dependabot alerts
   - ✅ Enable Dependabot security updates
   - ✅ Enable Code scanning alerts

## Step 3: Testing the Pipelines

### 3.1 Test tf-reusable-workflows Repository

1. Push the reusable workflows to the main branch
2. Verify no errors in Actions tab
3. Check that workflows are available for reuse

### 3.2 Test tf-plat-connectivity Repository

1. Create a feature branch:
   ```bash
   git checkout -b feature/test-pipeline
   git push origin feature/test-pipeline
   ```

2. Create a Pull Request - this should trigger:
   - ✅ Terraform Security Scan
   - ✅ Terraform Plan (with PR comment)

3. Merge to main - this should trigger:
   - ✅ Terraform Security Scan
   - ✅ Terraform Plan
   - ✅ Terraform Apply (with manual approval)

### 3.3 Test tf-subscription-vending-machine Repository

Follow the same process as above. This should deploy:
- Resource groups, VNet, subnets
- MongoDB VM with security misconfigurations
- AKS cluster
- Azure Container Registry
- Storage account
- Load balancer

## Step 4: Container and Kubernetes Pipeline (tf-wizardapp)

**Note: Only proceed after infrastructure is deployed**

### 4.1 Create tf-wizardapp Workflow

Create `tf-wizardapp/.github/workflows/app-build-deploy.yml`:

```yaml
name: 'Wizard App - Build & Deploy'

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy to'
        required: true
        default: 'nonprod'
        type: choice
        options:
        - nonprod
        - prod

permissions:
  id-token: write
  contents: read
  security-events: write
  pull-requests: write

jobs:
  # Build and scan container using reusable workflow
  build-and-scan:
    name: 'Build & Scan Container'
    uses: YOUR_ORG/tf-reusable-workflows/.github/workflows/container-build-scan.yml@main
    with:
      registry_name: 'acrwizappnonprod001'
      image_name: 'wizapp'
      environment: ${{ github.event.inputs.environment || 'nonprod' }}
      go_version: '1.19'
      run_tests: true
      validate_wizexercise: true
    permissions:
      id-token: write
      contents: read
      security-events: write
      packages: write

  # Deploy to Kubernetes using reusable workflow
  deploy-to-kubernetes:
    name: 'Deploy to Kubernetes'
    needs: build-and-scan
    if: |
      (github.ref == 'refs/heads/main' && github.event_name == 'push') ||
      (github.event_name == 'workflow_dispatch')
    uses: YOUR_ORG/tf-reusable-workflows/.github/workflows/kubernetes-deploy.yml@main
    with:
      environment: ${{ github.event.inputs.environment || 'nonprod' }}
      aks_resource_group: 'rg-wizapp-compute-nonprod-eastus2-001'
      aks_cluster_name: 'aks-wizapp-nonprod-eastus2-001'
      kubernetes_manifests: 'k8s-manifests.yaml'
      image_tag: ${{ needs.build-and-scan.outputs.image_tag }}
      namespace: 'wizapp'
      deployment_name: 'wizapp-deployment'
      service_name: 'wizapp-service'
      validate_wizexercise: true
      app_selector: 'app=wizapp'
    permissions:
      id-token: write
      contents: read
```

## Step 5: Deployment Sequence

### 5.1 Infrastructure Deployment

1. **Platform Connectivity** (tf-plat-connectivity):
   ```bash
   # Trigger via GitHub Actions or manual workflow dispatch
   # This deploys the hub-and-spoke network foundation
   ```

2. **Application Infrastructure** (tf-subscription-vending-machine):
   ```bash
   # Trigger after platform connectivity is deployed
   # This deploys VMs, AKS, ACR, Storage, etc.
   ```

### 5.2 Application Deployment

3. **Container Build & Deploy** (tf-wizardapp):
   ```bash
   # Trigger after application infrastructure is ready
   # This builds the container and deploys to Kubernetes
   ```

## Step 6: Security Scanning Results

### 6.1 Viewing Security Results

1. **GitHub Security Tab**: View all SARIF results
2. **Actions Summary**: See security scan summaries  
3. **Pull Request Comments**: Terraform plan results
4. **Dependabot**: Dependency vulnerability alerts

### 6.2 Expected Security Findings

The pipelines will identify:
- ✅ **Infrastructure**: Overly permissive VM roles, public access
- ✅ **Containers**: Outdated base images, vulnerabilities
- ✅ **Code**: Go security issues, secrets detection
- ✅ **Kubernetes**: Cluster-admin permissions, network policies

## Step 7: Troubleshooting

### 7.1 OIDC Authentication Issues

```bash
# Verify federated credentials
az ad app federated-credential list --id $APP_REGISTRATION

# Check service principal
az ad sp show --id $APP_REGISTRATION
```

### 7.2 Terraform State Issues

```bash
# List state files
az storage blob list \
  --container-name tfstate \
  --account-name $STORAGE_ACCOUNT_NAME \
  --output table
```

### 7.3 Pipeline Failures

1. Check GitHub Actions logs
2. Verify environment variables are set
3. Confirm Azure permissions
4. Check Terraform syntax

## Step 8: Demonstration Checklist

- [ ] All reusable workflows created and functional
- [ ] Infrastructure pipelines deploying successfully
- [ ] Security scans reporting findings
- [ ] Container builds and pushes to ACR
- [ ] Kubernetes deployments working
- [ ] wizexercise.txt validated in running pods
- [ ] Security misconfigurations visible in scan results
- [ ] Pull request approval workflows functioning
- [ ] Environment-based deployments working

## Best Practices Demonstrated

✅ **Reusable Workflows**: Eliminate code duplication across repositories  
✅ **Security-First**: Multiple scanning tools at every stage  
✅ **OIDC Authentication**: No secrets stored in GitHub  
✅ **Environment Management**: Proper approval gates  
✅ **Infrastructure as Code**: Everything version controlled  
✅ **GitOps Approach**: Pull-based deployments  
✅ **Compliance Ready**: SARIF results, audit trails  
✅ **Zero-Trust Security**: Minimal required permissions  

---

## Summary

This DevSecOps setup showcases enterprise-grade CI/CD pipelines with:

- **4 reusable workflows** for consistent deployment patterns
- **Comprehensive security scanning** at every stage
- **Azure OIDC authentication** for secure, secret-less access
- **Multi-environment deployment** with proper approval gates
- **Infrastructure as Code** with Terraform
- **Container security** with vulnerability scanning
- **Kubernetes deployment** with health checks

The result is a production-ready DevSecOps pipeline that demonstrates security best practices while maintaining development velocity. 