param environmentName string = 'aca-env'
param appName string = 'cludale-app'
param containerImage string = 'acrcludale.azurecr.io/cludale:latest'
param acrServer string = 'acrcludale.azurecr.io'
param acrUsername string
param acrPassword string
module acaModule 'aca.bicep' = {
  name: 'acaModule'
  params: {
    location: location
    environmentName: environmentName
    appName: appName
    containerImage: containerImage
    acrServer: acrServer
    acrUsername: acrUsername
    acrPassword: acrPassword
  }
}
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
