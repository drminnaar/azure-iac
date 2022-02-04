param appNamePrefix string
param location string = resourceGroup().location

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

output appServicePlanId string = asp.id
