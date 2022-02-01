param namePrefix string = 'sandbox-learn'
param location string = resourceGroup().location
param adminPassword string

// declare general variables
var uniqueId = uniqueString(resourceGroup().id)

// declare vnet variables
var vnetName = '${namePrefix}-${uniqueId}-vnet'
var vnetAddressPrefix = '10.0.0.0/16'


// declare vnet resource
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

module appTier 'modules/app-tier.bicep' = {
  name: '${namePrefix}-${uniqueId}-app-subnet'
  params: {
    appAdminPassword: adminPassword
    appAdminUsername: 'cloud_admin'
    vnetName: vnetName
  }
}

module dbTier 'modules/db-tier.bicep' = {
  name: '${namePrefix}-${uniqueId}-db-subnet'
  params: {
    dbAdminPassword: adminPassword
    dbAdminUsername: 'cloud_admin'
    vnetName: vnetName
  }
}
