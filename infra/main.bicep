// main.bicep
// Orchestrator for Cludale Azure-native app

param location string = 'canadaeast'

// ---------- ACR ----------
param acrName string = 'acrcludale'

module acrModule 'acr.bicep' = {
  name: 'acrModule'
  params: {
    location: location
    acrName: acrName
  }
}

// ---------- SQL ----------
param sqlServerName string = 'cludale-sqlserver'
param sqlDbName string = 'ConcertServiceDb'
param sqlAdminUser string = 'sqladminuser'
@secure()
param sqlAdminPassword string

// Azure AD admin (for Managed Identity access)
param aadAdminLogin string
param aadAdminObjectId string

module sqlModule 'sql.bicep' = {
  name: 'sqlModule'
  params: {
    location: location
    sqlServerName: sqlServerName
    sqlDbName: sqlDbName
    administratorLogin: sqlAdminUser
    administratorPassword: sqlAdminPassword
    aadAdminLogin: aadAdminLogin
    aadAdminObjectId: aadAdminObjectId
  }
}

// ---------- ACA ----------
param environmentName string = 'aca-env'
param appName string = 'cludale-app'
param imageTag string

var containerImage = '${acrModule.outputs.loginServer}/cludale:${imageTag}'

module acaModule 'aca.bicep' = {
  name: 'acaModule'
  params: {
    location: location
    environmentName: environmentName
    appName: appName
    containerImage: containerImage
    acrServer: acrModule.outputs.loginServer
    sqlServerFqdn: sqlModule.outputs.sqlServerFqdn
    sqlDbName: sqlModule.outputs.sqlDbNameOut
  }
}

// ---------- RBAC: ACA → ACR (AcrPull) ----------
resource acrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(
    acrModule.outputs.acrId,
    acaModule.outputs.managedIdentityPrincipalId,
    'acrpull'
  )
  scope: acrModule.outputs.acrId
  dependsOn: [
    acrModule
    acaModule
  ]
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '7f951dda-4ed3-4680-a7ca-43fe172d538d' // AcrPull
    )
    principalId: acaModule.outputs.managedIdentityPrincipalId
    principalType: 'ServicePrincipal'
  }
}

// ---------- Outputs ----------
output acaFqdn string = acaModule.outputs.fqdn
output acrLoginServer string = acrModule.outputs.loginServer
output sqlServerFqdn string = sqlModule.outputs.sqlServerFqdn
