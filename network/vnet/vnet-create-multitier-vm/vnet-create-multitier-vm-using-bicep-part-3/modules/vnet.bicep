// declare parameters
param namePrefix string
param location string = resourceGroup().location

@secure()
param adminUsername string

@secure()
param adminPassword string


// declare vnet variables
var vnetName = '${namePrefix}-vnet'
var vnetAddressPrefix = '10.0.0.0/16'


// declare resources
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]      
    }
  }
}


// declare modules
module appTier 'app-tier.bicep' = {
  name: '${namePrefix}-app-subnet'
  params: {
    appAdminPassword: adminPassword
    appAdminUsername: adminUsername
    vnetName: vnetName
    namePrefix: namePrefix
  }
}

module dbTier 'db-tier.bicep' = {
  name: '${namePrefix}-db-subnet'
  params: {
    dbAdminPassword: adminPassword
    dbAdminUsername: adminUsername
    vnetName: vnetName
    namePrefix: namePrefix
  }
}
