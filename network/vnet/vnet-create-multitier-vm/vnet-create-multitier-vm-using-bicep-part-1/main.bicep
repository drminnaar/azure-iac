param namePrefix string = 'sandbox-learn'
param location string = resourceGroup().location

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



/***************************************************
 * CREATE APP TIER
 ***************************************************/
param appAdminUsername string = 'cloud_admin'
param appAdminPassword string
var appSubnetName = '${namePrefix}-${uniqueId}-app-subnet'
var appSubnetAddressPrefix = '10.0.0.0/24'

// create app nsg
resource appNsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: '${namePrefix}-${uniqueId}-app-nsg'
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

// create app subnet
resource appSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  parent: vnet
  name: appSubnetName  
  properties: {
    addressPrefix: appSubnetAddressPrefix
    networkSecurityGroup: {
      id: appNsg.id
    }
  }
}

// create public IP
resource appVmPip 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: '${namePrefix}-${uniqueId}-app-vm-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
}

// create network interface
resource appVmNic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: '${namePrefix}-${uniqueId}-app-vm-nic'
  location: location
  properties: {
    networkSecurityGroup: {
      id: appNsg.id
    }
    ipConfigurations: [
      {
        name: '${namePrefix}-${uniqueId}-app-vm-nic-ipconf'
        properties: {
          publicIPAddress: {
            id: appVmPip.id
          }
          subnet: {
            id: appSubnet.id
          }
        }
      }
    ]
  }
}

// create app VM
resource appVm 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: '${namePrefix}-${uniqueId}-app-vm'
  location: location
  properties: {    
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
    }
    osProfile: {
      computerName: '${namePrefix}-${uniqueId}-app-vm'
      adminUsername: appAdminUsername
      adminPassword: appAdminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: appVmNic.id
          properties: {
            primary: true
          }
        }
      ]
    }
  }
}



/***************************************************
 * CREATE DB TIER
 ***************************************************/
param dbAdminUsername string = 'cloud_admin'
param dbAdminPassword string
var dbSubnetName = '${namePrefix}-${uniqueId}-db-subnet'
var dbSubnetAddressPrefix = '10.0.1.0/24'

// create db network security group
resource dbNsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: '${namePrefix}-${uniqueId}-db-nsg'
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
          sourceAddressPrefix: dbSubnetAddressPrefix
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

// create db subnet
resource dbSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  parent: vnet
  name: dbSubnetName
  properties: {
    addressPrefix: dbSubnetAddressPrefix
    networkSecurityGroup: {
      id: dbNsg.id
    }
  }
}

// create db public IP
resource dbVmPip 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: '${namePrefix}-${uniqueId}-db-vm-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
}

// create network interface
resource dbVmNic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: '${namePrefix}-${uniqueId}-db-vm-nic'
  location: location
  properties: {
    networkSecurityGroup: {
      id: dbNsg.id
    }
    ipConfigurations: [
      {
        name: '${namePrefix}-${uniqueId}-db-vm-nic-ipconf'
        properties: {
          publicIPAddress: {
            id: dbVmPip.id
          }
          subnet: {
            id: dbSubnet.id
          }
        }
      }
    ]
  }
}

// create db VM
resource dbVm 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: '${namePrefix}-${uniqueId}-db-vm'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
    }
    osProfile: {
      computerName: '${namePrefix}-${uniqueId}-db-vm'
      adminUsername: dbAdminUsername
      adminPassword: dbAdminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: dbVmNic.id
          properties: {
            primary: true
          }
        }
      ]
    }
  }
}
