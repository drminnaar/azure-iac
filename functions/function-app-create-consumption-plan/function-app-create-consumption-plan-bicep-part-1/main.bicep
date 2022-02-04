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

// create app service plan
resource asp 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: '${appNamePrefix}-asp'
  location: location
  kind: 'linux'
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
    size: 'Y1'
    family: 'Y'
    capacity: 0
  }
  properties: {
    reserved: true
  }
}

// create function app
resource fapp 'Microsoft.Web/sites@2021-02-01' = {
  name: '${appNamePrefix}-fapp'
  location: location
  kind: 'functionapp,linux'
  properties: {
    enabled: true
    serverFarmId: asp.id
    siteConfig: {      
      numberOfWorkers: 1
      linuxFxVersion: 'DOTNET|6.0'
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${sta.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${sta.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${sta.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${sta.listKeys().keys[0].value}'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
      ]
    }
    httpsOnly: false
  }
}
