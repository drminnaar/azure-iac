param appNamePrefix string
param storageAccountName string
param storageAccountKey string
param appServicePlanId string
param location string = resourceGroup().location

// create function app
resource fapp 'Microsoft.Web/sites@2021-02-01' = {
  name: '${appNamePrefix}-fapp'
  location: location
  kind: 'functionapp,linux'
  properties: {
    enabled: true
    serverFarmId: appServicePlanId
    siteConfig: {      
      numberOfWorkers: 1
      linuxFxVersion: 'DOTNET|6.0'
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccountKey}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccountKey}'
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

output functionAppName string = fapp.name
