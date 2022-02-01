// define scope
targetScope = 'subscription'


// define parameters
param namePrefix string = 'aziac'
param location string = deployment().location


// define variables
var uniqueId = uniqueString(deployment().name)
var rgName = '${namePrefix}-${uniqueId}-rg'


// define resources
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}


// define modules
module cosmosModule 'modules/cosmosdb.bicep' = {
  scope: resourceGroup
  name: '${namePrefix}-${uniqueId}-cosmosdb'
  params: {
    location: location
    databaseName: 'weatherdb'
  }
}


// output resource group info
output resourceGroupName string = resourceGroup.name

// output cosmosdb info
output accountName string = cosmosModule.outputs.accountName
output dbName string = cosmosModule.outputs.dbName
