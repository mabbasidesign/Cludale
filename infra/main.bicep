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


param location string = 'westus'
param acrName string = 'acrcludale'

module acrModule 'acr.bicep' = {
  name: 'acrModule'
  params: {
    location: location
    acrName: acrName
  }
}


// Azure SQL parameters
param sqlServerName string = 'cludale-sqlserver2'
param sqlDbName string = 'ConcertServiceDb2'
param sqlAdminUser string = 'sqladminuser'
@secure()
param sqlAdminPassword string

module sqlModule 'sql.bicep' = {
  name: 'sqlModule'
  params: {
    location: location
    sqlServerName: sqlServerName
    sqlDbName: sqlDbName
    administratorLogin: sqlAdminUser
    administratorPassword: sqlAdminPassword
  }
}
