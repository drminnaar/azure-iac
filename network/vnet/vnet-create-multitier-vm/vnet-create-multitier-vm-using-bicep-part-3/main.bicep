targetScope = 'subscription'

param namePrefix string = 'sandbox-learn-${uniqueString(newGuid())}'
param location string = deployment().location
param adminPassword string


// declare general variables
var rgName = '${namePrefix}-rg'


// define resources
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}


// define modules
module vnet 'modules/vnet.bicep' = {
  scope: resourceGroup
  name: '${namePrefix}-deployment'
  params: {
    location: location
    namePrefix: namePrefix
    adminPassword: adminPassword
    adminUsername: 'cloud_admin'
  }
}

output resourceGroupName string = resourceGroup.name
