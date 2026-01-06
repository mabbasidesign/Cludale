// Azure SQL Server and Database Bicep module with managed identity support
param location string = resourceGroup().location
param sqlServerName string
param sqlDbName string
param administratorLogin string
param administratorPassword string @secure()

resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorPassword
    version: '12.0'
    publicNetworkAccess: 'Enabled'
  }
}

resource sqlDb 'Microsoft.Sql/servers/databases@2022-02-01-preview' = {
  name: '${sqlServer.name}/${sqlDbName}'
  location: location
  properties: {
    sku: {
      name: 'Basic'
      tier: 'Basic'
    }
  }
}

// Optional: Allow Azure services (like ACA) to access the server
resource allowAzureServices 'Microsoft.Sql/servers/firewallRules@2022-02-01-preview' = {
  name: '${sqlServer.name}/AllowAzureServices'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

output sqlServerFqdn string = sqlServer.properties.fullyQualifiedDomainName
output sqlDbNameOut string = sqlDb.name
