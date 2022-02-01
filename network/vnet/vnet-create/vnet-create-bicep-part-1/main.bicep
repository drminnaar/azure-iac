@description('The value to prefix vnet name with')
param namePrefix string = 'aziac'

@description('Location for all resources')
param location string = resourceGroup().location


// define general variables
var uniqueId = uniqueString(resourceGroup().id)

// define vnet variables
var vnetName = '${namePrefix}-${uniqueId}-vnet'
var vnetAddressPrefix = '10.0.0.0/16'

// define app subnet variables
var appSubnetName = '${namePrefix}-${uniqueId}-app-subnet'
var appSubnetAddressPrefix = '10.0.0.0/24'

// define db subnet variables
var dbSubnetName = '${namePrefix}-${uniqueId}-db-subnet'
var dbSubnetAddressPrefix = '10.0.1.0/24'


// define resource
resource vnet 'Microsoft.Network/virtualNetworks@2021-03-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: appSubnetName
        properties: {
          addressPrefix: appSubnetAddressPrefix
        }
      }
      {
        name: dbSubnetName
        properties: {
          addressPrefix: dbSubnetAddressPrefix
        }
      }
    ]
  }
}

// output vnet info
output vnetName string = vnet.name
output vnetAddressPrefix string = vnet.properties.addressSpace.addressPrefixes[0]

// output app subnet info
output appSubnetName string = vnet.properties.subnets[0].name
output appSubnetAddressPrefix string = vnet.properties.subnets[0].properties.addressPrefix

// output db subnet info
output dbSubnetName string = vnet.properties.subnets[1].name
output dbSubnetAddressPrefix string = vnet.properties.subnets[1].properties.addressPrefix
