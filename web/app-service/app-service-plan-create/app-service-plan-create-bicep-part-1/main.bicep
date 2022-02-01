@description('The name of app')
param websiteName string

@description('The location of all resources')
param location string = resourceGroup().location

@description('The Runtime stack of current web app')
param linuxFxVersion string = 'DOTNETCORE|6.0'

@allowed([
  'F1'
  'B1'
])
param skuName string = 'F1'

@description('The url of the .NET web application')
param repoUrl string

var uniqueId = uniqueString(resourceGroup().id)
var normalizedWebsiteName = toLower(websiteName)
var appName = '${normalizedWebsiteName}-${uniqueId}-app'
var appPlanName = '${normalizedWebsiteName}-${uniqueId}-plan'

resource appPlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appPlanName
  location: location
  kind: 'linux'
  sku: {
    name: skuName
  }
  properties: {
    reserved: true
  }
}

resource app 'Microsoft.Web/sites@2021-02-01' = {
  name: appName
  location: location
  properties: {
    serverFarmId: appPlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: linuxFxVersion
    }
  }
}

resource srcControls 'Microsoft.Web/sites/sourcecontrols@2021-01-01' = {
  name: '${app.name}/web'
  properties: {
    repoUrl: repoUrl
    branch: 'main'
    isManualIntegration: true
  }
}
