param namePrefix string = 'sandbox-learn'
@secure()
param appAdminUsername string
@secure()
param appAdminPassword string

param location string = resourceGroup().location
param vnetName string

var uniqueId = uniqueString(resourceGroup().id)
var appSubnetName = '${namePrefix}-${uniqueId}-app-subnet'
var appSubnetAddressPrefix = '10.0.0.0/24'
var customAppVmData = '''
#cloud-config
package_update: true
package_upgrade: true
packages:
  - nginx
  - nodejs
  - npm
  - tree
  - vim
  - jq
runcmd:
  - service nginx restart
'''

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
      customData: base64(customAppVmData)
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

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetName
}

output appSubnetId string = appSubnet.id
output appSubnetName string = appSubnet.name
