param namePrefix string = 'sandbox-learn'
param location string = resourceGroup().location

var uniqueId = uniqueString(resourceGroup().id)

// declare app subnet variables
var appSubnetName = '${namePrefix}-${uniqueId}-app-subnet'
var appSubnetAddressPrefix = '10.0.0.0/24'

// declare db subnet variables
var dbSubnetName = '${namePrefix}-${uniqueId}-db-subnet'
var dbSubnetAddressPrefix = '10.0.1.0/24'

// declare vnet variables
var vnetName = '${namePrefix}-${uniqueId}-vnet'
var vnetAddressPrefix = '10.0.0.0/16'

// declare app nsg variables
var appNsgName = '${namePrefix}-${uniqueId}-app-nsg'

// declare db nsg variables
var dbNsgName = '${namePrefix}-${uniqueId}-db-nsg'

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
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
          networkSecurityGroup: {
            id: appNsg.id
          }
        }
      }
      {
        name: dbSubnetName
        properties: {
          addressPrefix: dbSubnetAddressPrefix
          networkSecurityGroup: {
            id: dbNsg.id
          }
        }
      }
    ]
  }
}

resource appNsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: appNsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-http-inbound'
        properties: {
          description: 'Allow inbound http traffic'
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          priority: 100
          sourceAddressPrefix: 'Internet'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '80'
        }
      }
      {
        name: 'allow-ssh-inbound'
        properties: {
          description: 'Allow inbound ssh traffic'
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          priority: 300
          sourceAddressPrefix: 'Internet'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
}

resource dbNsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: dbNsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-mongo-inbound'
        properties: {
          description: 'All inbound Mongodb traffic'
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          priority: 100
          sourcePortRange: '*'
          destinationPortRange: '21017'
          sourceAddressPrefix: appSubnetAddressPrefix
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'allow-ssh-inbound'
        properties: {
          description: 'All inbound SSH'
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          priority: 200
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'deny-internet-outbound'
        properties: {
          description: 'Deny all outgoing internet traffic'
          protocol: 'Tcp'
          access: 'Deny'
          direction: 'Outbound'
          priority: 300
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }      
      }
    ]
  }
}
