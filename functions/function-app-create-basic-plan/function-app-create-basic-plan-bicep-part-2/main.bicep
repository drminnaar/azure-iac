targetScope = 'subscription'

param appNamePrefix string
param location string = deployment().location

// define resource group
var rgName = '${appNamePrefix}-rg'
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

module staModule 'modules/storageaccount.bicep' = {
  scope: resourceGroup
  name: '${appNamePrefix}-sta-module'
  params: {
    appNamePrefix: appNamePrefix
  }
}

module aspModule 'modules/appsvcplan.bicep' = {
  scope: resourceGroup
  name: '${appNamePrefix}-asp-module'
  params: {
    appNamePrefix: appNamePrefix
  }
}

module fappModule 'modules/funcapp.bicep' = {
  scope: resourceGroup
  name: '${appNamePrefix}-fapp-module'
  params: {
    appNamePrefix: appNamePrefix
    appServicePlanId: aspModule.outputs.appServicePlanId
    storageAccountName: staModule.outputs.storageAccountName
    storageAccountKey: staModule.outputs.storageAccountKey
  }
}

output resourceGroupName string = resourceGroup.name
output storageAccountName string = staModule.outputs.storageAccountName
output appServicePlanId string = aspModule.outputs.appServicePlanId
output functionAppName string = fappModule.outputs.functionAppName
