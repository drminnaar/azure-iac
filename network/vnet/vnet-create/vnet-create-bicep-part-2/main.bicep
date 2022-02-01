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
module vnetModule 'modules/vnet.bicep' = {
  scope: resourceGroup
  name: '${namePrefix}-${uniqueId}-vnet-module'
  params: {
    location: location
    namePrefix: namePrefix
  }
}


// output resource group info
output resourceGroupName string = resourceGroup.name

// output vnet info
output vnetName string = vnetModule.outputs.vnetName
output vnetAddressPrefix string = vnetModule.outputs.vnetAddressPrefix

// output app subnet info
output appSubnetName string = vnetModule.outputs.appSubnetName
output appSubnetAddressPrefix string = vnetModule.outputs.appSubnetAddressPrefix

// output db subnet info
output dbSubnetName string = vnetModule.outputs.dbSubnetName
output dbSubnetAddressPrefix string = vnetModule.outputs.dbSubnetAddressPrefix
