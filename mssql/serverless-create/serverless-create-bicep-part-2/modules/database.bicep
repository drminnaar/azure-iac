@description('Globally unique server name')
param serverName string

@description('Database name')
param databaseName string

@description('Server and Database location')
param location string

@allowed([
  'AdventureWorksLT'
  'WideWorldImportersFull'
  'WideWorldImportersStd'
])
@description('The name of the sample schema to apply when creating this database.')
param sampleName string = 'AdventureWorksLT'

resource server 'Microsoft.Sql/servers@2021-11-01-preview' existing = {
  name: serverName  
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
