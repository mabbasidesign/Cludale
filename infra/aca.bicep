// aca.bicep
// Module for Azure Container Apps Environment and App
param location string
param environmentName string = 'aca-env'
param appName string = 'cludale-app'
param containerImage string
param acrServer string
param acrUsername string
param acrPassword string

resource acaEnv 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: environmentName
  location: location
  properties: {}
}

resource acaApp 'Microsoft.App/containerApps@2023-05-01' = {
  name: appName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    managedEnvironmentId: acaEnv.id
    configuration: {
      ingress: {
        external: true
        targetPort: 80
      }
      registries: [
        {
          server: acrServer
          username: acrUsername
          passwordSecretRef: 'acr-password'
        }
      ]
      secrets: [
        {
          name: 'acr-password'
          value: acrPassword
        }
      ]
    }
    template: {
      containers: [
        {
          image: containerImage
          name: appName
        }
      ]
    }
  }
}

output managedIdentityPrincipalId string = acaApp.identity.principalId
}
