// declare parameters
@secure()
param dbAdminUsername string
@secure()
param dbAdminPassword string
param vnetName string
param namePrefix string
param location string = resourceGroup().location

// declare variables
var dbSubnetName = '${namePrefix}-db-subnet'
var dbSubnetAddressPrefix = '10.0.1.0/24'

// create db network security group
resource dbNsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: '${namePrefix}-db-nsg'
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
  name: '${namePrefix}-db-vm-pip'
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
  name: '${namePrefix}-db-vm-nic'
  location: location
  properties: {
    networkSecurityGroup: {
      id: dbNsg.id
    }
    ipConfigurations: [
      {
        name: '${namePrefix}-db-vm-nic-ipconf'
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
  name: '${namePrefix}-db-vm'
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
      computerName: '${namePrefix}-db-vm'
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

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetName
}

output dbSubnetId string = dbSubnet.id
