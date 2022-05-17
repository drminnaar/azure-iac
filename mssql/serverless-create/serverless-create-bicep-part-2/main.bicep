// define scope

targetScope = 'subscription'

// define parameters

param location string = deployment().location

@description('Name of resource group')
param resourceGroupName string

@description('Globally unique server name')
param serverName string

@description('Database name')
param databaseName string

@secure()
@description('Administrator username for the server. Once created it cannot be changed.')
param administratorLogin string

@secure()
@description('The administrator login password (required for server creation)')
param administratorLoginPassword string

// define variables

var namePrefix = 'aziac'

// define resources

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

// define modules

module serverModule 'modules/server.bicep' = {
  scope: resourceGroup
  name: '${namePrefix}-sqlserver-module'
  params: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    location: location
    serverName: serverName
    publicNetworkAccess: 'Enabled'
  }
}

module databaseModule 'modules/database.bicep' = {
  scope: resourceGroup
  name: '${namePrefix}-sqldb-module'
  dependsOn: [
    serverModule
  ]
  params: {
    databaseName: databaseName
    location: location
    serverName: serverName
    sampleName: 'AdventureWorksLT'
  }
}

module firewallRulesModule 'modules/firewall-rules.bicep' = {
  scope: resourceGroup
  name: '${namePrefix}-sqlserver-fwrules-module'
  dependsOn: [
    serverModule
  ]
  params: {
    serverName: serverName
  }
}
