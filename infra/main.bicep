param location string = 'westus'
param imageTag string

// ---------- SQL bootstrap (ONLY for initial creation) ----------
param sqlServerName string = 'cludale-sqlserver'
param sqlDbName string = 'ConcertServiceDb'
param sqlAdminLogin string

@secure()
param sqlAdminPassword string

// Azure AD admin (human or group)
param aadAdminLogin string
param aadAdminObjectId string

// ---------- ACR ----------
param acrName string = 'acrcludale'

// ---------- ACA ----------
param environmentName string = 'aca-env'
param appName string = 'cludale-app'

// ================= MODULES =================

// ACR
module acr './acr.bicep' = {
  name: 'acrModule'
  params: {
    location: location
    acrName: acrName
  }
}

// SQL
module sql './sql.bicep' = {
  name: 'sqlModule'
  params: {
    location: location
    sqlServerName: sqlServerName
    sqlDbName: sqlDbName
    administratorLogin: sqlAdminLogin
    administratorPassword: sqlAdminPassword
    aadAdminLogin: aadAdminLogin
    aadAdminObjectId: aadAdminObjectId
  }
}

// ACA
module aca './aca.bicep' = {
  name: 'acaModule'
  params: {
    location: location
    appName: appName
    environmentName: environmentName
    acrLoginServer: acr.outputs.loginServer
    imageTag: imageTag
    sqlServerFqdn: sql.outputs.sqlServerFqdn
    sqlDatabaseName: sql.outputs.sqlDbNameOut
  }
}

// ================= SECURITY (RBAC) =================

// ACA → ACR (pull images using Managed Identity)
resource acrPull 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(acrName, appName, 'AcrPull')
    scope: resourceGroup()
    properties: {
      scope: resourceId('Microsoft.ContainerRegistry/registries', acrName)
      roleDefinitionId: subscriptionResourceId(
        'Microsoft.Authorization/roleDefinitions',
        '7f951dda-4ed3-4680-a7ca-43fe172d538d' // AcrPull
      )
      principalId: aca.outputs.principalId
      principalType: 'ServicePrincipal'
    }
}

// ================= OUTPUTS =================

output acaFqdn string = aca.outputs.fqdn
output acrLoginServer string = acr.outputs.loginServer
output sqlServerFqdn string = sql.outputs.sqlServerFqdn
