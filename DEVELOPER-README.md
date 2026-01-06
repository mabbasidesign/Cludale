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

## Secure Azure SQL Deployment with Managed Identity

### Step-by-Step Guide

1. **Provision Azure SQL and Managed Identity with Bicep**
   - The Bicep modules (infra/sql.bicep, infra/main.bicep, infra/aca.bicep) provision Azure SQL Database and enable managed identity for ACA.
   - The deployment region is set via the `location` parameter (e.g., `eastus`).

2. **Configure Pipeline for Secure Parameters**
   - Add `sqlAdminPassword` as a secure variable in Azure DevOps.
   - The pipeline passes this to Bicep for SQL admin creation.

3. **Deploy Resources**
   - Run the pipeline to deploy all resources to the chosen region.
   - If region restrictions occur, switch to a supported region (e.g., eastus).

4. **Grant ACA Managed Identity Access to SQL**
   - After deployment, get the ACA app's managed identity principalId from the Azure Portal or CLI.
   - Connect to Azure SQL as admin (using SSMS, Azure Data Studio, or Portal Query Editor).
   - Run:
     ```sql
     CREATE USER [<principalId>] FROM EXTERNAL PROVIDER;
     ALTER ROLE db_owner ADD MEMBER [<principalId>];
     ```

5. **Update .NET App for Azure AD Authentication**
   - Use a connection string like:
     `Server=tcp:<your-server>.database.windows.net,1433;Database=ConcertServiceDb;Authentication=Active Directory Managed Identity;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;`
   - No username or password required in code.

6. **Switch Regions (Optional)**
   - To use a different region, update the `location` parameter in Bicep and pipeline, then redeploy.

7. **Cleanup**
   - Remove unused resources in old regions to avoid confusion and extra costs.

For questions or improvements, contact the DevOps team.
