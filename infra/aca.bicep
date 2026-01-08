// aca.bicep
param location string
param environmentName string
param appName string
param containerImage string
param acrServer string

// SQL inputs (passed from main.bicep)
param sqlServerFqdn string
param sqlDbName string

resource acaEnv 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: environmentName
  location: location
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
          identity: 'SystemAssigned' // ✅ Explicit MI usage
        }
      ]
    }
    template: {
      containers: [
        {
          name: appName
          image: containerImage
          resources: {
            cpu: 0.5
            memory: '1Gi'
          }
          env: [
            {
              name: 'SQL_SERVER'
              value: sqlServerFqdn
            }
            {
              name: 'SQL_DATABASE'
              value: sqlDbName
            }
          ]
        }
      ]
    }
  }
}

output managedIdentityPrincipalId string = acaApp.identity.principalId
output fqdn string = acaApp.properties.configuration.ingress.fqdn
