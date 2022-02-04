// define scope
targetScope = 'subscription'


// define parameters
param appNamePrefix string


// define variables
@description('The name of resource group')
var rgName = '${appNamePrefix}-rg'

@description('The location of all resources')
var location = deployment().location


// define resources
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}


// define modules
module sta 'modules/storageaccount.bicep' = {
  scope: resourceGroup
  name: '${appNamePrefix}-${uniqueString(resourceGroup.id)}-deployment'
  params: {
    appNamePrefix: appNamePrefix
  }
}


// define outputs
output storageAccountName string = sta.outputs.storageAccountName
output resourceGroupName string = resourceGroup.name
