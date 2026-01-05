# Cludale Developer Guide

## Overview
This project demonstrates a modern DevOps workflow for a .NET application using Azure DevOps, Docker, Azure Container Registry (ACR), Bicep, and Azure Container Apps (ACA).

## Project Structure
- **src/**: .NET source code (ConcertService)
- **infra/**: Infrastructure as Code (Bicep modules)
  - `main.bicep`: Orchestrates all modules
  - `acr.bicep`: Provisions Azure Container Registry
  - `aca.bicep`: Provisions ACA environment and app
- **pipeline/azure-pipelines.yml**: Multi-stage Azure DevOps pipeline

## CI/CD Pipeline Stages
1. **Build**: Restores, builds, and publishes the .NET app.
2. **Docker**: Builds and pushes a Docker image to ACR.
3. **Deploy**: Deploys infrastructure and ACA app using Bicep.

## Key Azure Resources
- **Resource Group**: `rg-cludale` (canadaeast)
- **ACR**: `acrcludale`
- **ACA Environment**: `aca-env`
- **ACA App**: `cludale-app`

## Pipeline Secrets/Variables
- `ACR_USERNAME`: ACR admin username or service principal
- `ACR_PASSWORD`: ACR admin password or service principal secret (mark as secret)

## How It Works
- The pipeline builds and publishes the .NET app.
- Docker@2 builds and pushes the image to ACR.
- AzureCLI@2 deploys Bicep templates, passing ACR credentials to ACA.
- ACA pulls the image from ACR using the provided credentials.

## How to Set Up
1. **Create Azure Resources**
   - Resource group: `az group create --name rg-cludale --location canadaeast`
   - ACR: Deploy via Bicep or portal
2. **Configure Azure DevOps**
   - Create service connections for Azure and ACR
   - Add pipeline secrets: `ACR_USERNAME`, `ACR_PASSWORD`
3. **Run the Pipeline**
   - The pipeline will build, push, and deploy automatically.

## Security Notes
- Store secrets in Azure DevOps as pipeline secrets.
- For production, consider using managed identity for ACA instead of passing credentials.

## Useful Commands
- List ACR repos: `az acr repository list --name acrcludale --output table`
- List tags: `az acr repository show-tags --name acrcludale --repository cludale --output table`
- Deploy Bicep manually: `az deployment group create --resource-group rg-cludale --template-file infra/main.bicep --parameters acrUsername=... acrPassword=...`

## Further Enhancements
- Add automated tests and publish results
- Use Blue/Green or Canary deployments
- Integrate monitoring and alerts
- Use Key Vault for secret management

---
For questions or improvements, contact the DevOps team.
