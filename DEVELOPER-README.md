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

> **Note:** ACR credentials are no longer required. ACA uses managed identity for secure image pulls from ACR.

## How It Works
- The pipeline builds and publishes the .NET app.
- Docker@2 builds and pushes the image to ACR.
- AzureCLI@2 deploys Bicep templates. ACA pulls the image from ACR using its managed identity (no credentials needed).

## How to Set Up
1. **Create Azure Resources**
   - Resource group: `az group create --name rg-cludale --location canadaeast`
   - ACR: Deploy via Bicep or portal
2. **Configure Azure DevOps**
   - Create a service connection for Azure
   - No ACR credentials are needed; ACA uses managed identity
3. **Run the Pipeline**
   - The pipeline will build, push, and deploy automatically.

## Security Notes
- Store only SQL admin password as a pipeline secret.
- ACA and ACR use managed identity for secure, passwordless access.

## Useful Commands
- List ACR repos: `az acr repository list --name acrcludale --output table`
- List tags: `az acr repository show-tags --name acrcludale --repository cludale --output table`
- Deploy Bicep manually: `az deployment group create --resource-group rg-cludale --template-file infra/main.bicep --parameters location=canadaeast ...`

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
    - After deployment, get the ACA app's managed identity principalId from the Azure Portal, CLI, or Bicep output.
    - Connect to your Azure SQL database as an Azure AD admin (using SSMS, Azure Data Studio, or Portal Query Editor).
    - Run:
       ```sql
       CREATE USER [aca-managed-identity] FROM EXTERNAL PROVIDER WITH SID = '<principalId>';
       ALTER ROLE db_datareader ADD MEMBER [aca-managed-identity];
       ALTER ROLE db_datawriter ADD MEMBER [aca-managed-identity];
       ```
    - Replace `[aca-managed-identity]` with a name for the user, and `<principalId>` with the managed identity's objectId (GUID).

5. **Update .NET App for Azure AD Authentication**
    - Use a connection string like:
       `Server=tcp:<your-server>.database.windows.net,1433;Database=ConcertServiceDb;Authentication=Active Directory Default;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;`
    - No username or password required in code. Use `DefaultAzureCredential` in your .NET app for best results.

6. **Switch Regions (Optional)**
   - To use a different region, update the `location` parameter in Bicep and pipeline, then redeploy.

7. **Cleanup**
   - Remove unused resources in old regions to avoid confusion and extra costs.

For questions or improvements, contact the DevOps team.
