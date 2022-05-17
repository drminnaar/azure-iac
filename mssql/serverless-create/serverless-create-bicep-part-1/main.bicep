@description('Globally unique server name')
param serverName string

@description('Database name')
param databaseName string

@description('Server and Database location')
param location string = resourceGroup().location

@ allowed([
  'Enabled'
  'Disabled'
])
@description('Whether or not public endpoint access is allowed for this server. Value is optional but if passed in, must be "Enabled" or "Disabled"')
param publicNetworkAccess string = 'Disabled'

@ allowed([
  'Enabled'
  'Disabled'
])
@description('Whether or not public endpoint access is allowed for this server. Value is optional but if passed in, must be "Enabled" or "Disabled"')
param restrictOutboundNetworkAccess string = 'Disabled'

@allowed([
  'AdventureWorksLT'
  'WideWorldImportersFull'
  'WideWorldImportersStd'
])
@description('The name of the sample schema to apply when creating this database.')
param sampleName string = 'AdventureWorksLT'

@secure()
@description('Administrator username for the server. Once created it cannot be changed.')
param administratorLogin string

@secure()
@description('The administrator login password (required for server creation)')
param administratorLoginPassword string

resource server 'Microsoft.Sql/servers@2021-11-01-preview' = {
  name: serverName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword:administratorLoginPassword
    publicNetworkAccess: publicNetworkAccess
    restrictOutboundNetworkAccess: restrictOutboundNetworkAccess
    version: '12.0'
  }  
}

resource allowAllAzureIps 'Microsoft.Sql/servers/firewallRules@2021-11-01-preview' = {
  parent: server
  name: 'AllowAllAzureIps'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource allowClientIps 'Microsoft.Sql/servers/firewallRules@2021-11-01-preview' = {
  parent: server
  name: 'AllowClientIps'
  properties: {
    startIpAddress: '219.88.235.68'
    endIpAddress: '219.88.235.68'
  }
}

resource database 'Microsoft.Sql/servers/databases@2021-11-01-preview' = {
  name: databaseName
  location: location
  parent: server
  properties: {
    autoPauseDelay: 60
    maxSizeBytes: 2147483648
    minCapacity: 1
    sampleName: sampleName
    zoneRedundant: false
  }
  sku: {
    name: 'GP_S_Gen5' // Get-AzSqlServerServiceObjective -Location 'australiaeast', az sql db list-editions --location 'australiaeast' --output table
    family: 'Gen5'
    tier: 'GeneralPurpose'
    capacity: 1    
  }
}
