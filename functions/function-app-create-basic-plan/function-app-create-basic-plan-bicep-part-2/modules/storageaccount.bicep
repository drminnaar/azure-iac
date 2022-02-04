param appNamePrefix string
param location string = resourceGroup().location

// create storage account
resource sta 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: replace('${appNamePrefix}sta', '-', '')
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

// determine account key
var key = sta.listKeys().keys[0].value

output storageAccountName string = sta.name
output storageAccountKey string = key
