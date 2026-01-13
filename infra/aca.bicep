param location string
param appName string
param environmentName string

param acrLoginServer string
param imageTag string

param sqlServerFqdn string
param sqlDatabaseName string

resource env 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: environmentName
  location: location
}

resource app 'Microsoft.App/containerApps@2023-05-01' = {
  name: appName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    managedEnvironmentId: env.id
    configuration: {
      ingress: {
        external: true
        targetPort: 80
      }
      registries: [
        {
          server: acrLoginServer
        }
      ]
    }
    template: {
      containers: [
        {
          name: appName
          image: '${acrLoginServer}/cludale:${imageTag}'
          resources: {
            cpu: 1
            memory: '1Gi'
          }
          env: [
            {
              name: 'SQL_SERVER'
              value: sqlServerFqdn
            }
            {
              name: 'SQL_DATABASE'
              value: sqlDatabaseName
            }
          ]
        }
      ]
    }
  }
}

output principalId string = app.identity.principalId
output fqdn string = app.properties.configuration.ingress.fqdn
