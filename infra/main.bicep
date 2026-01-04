// main.bicep
// Bicep template to provision a Resource Group and Azure Container Registry (ACR)


param location string = 'canadaeast'
param acrName string = 'acrcludale'

module acrModule 'acr.bicep' = {
  name: 'acrModule'
  params: {
    location: location
    acrName: acrName
  }
}

// Add more resources (e.g., ACA, App Service, Cosmos DB, SQL) as needed
