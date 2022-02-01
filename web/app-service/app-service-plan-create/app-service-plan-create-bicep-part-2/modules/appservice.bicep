// define parameters
@description('The name of web site')
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

@description('The url of the .net web application')
param repoUrl string


// define variables
var uniqueId = uniqueString(resourceGroup().id)
var normalizedWebsiteName = toLower(websiteName)
var appName = '${normalizedWebsiteName}-${uniqueId}-app'
var appPlanName = '${normalizedWebsiteName}-${uniqueId}-plan'


// define resources
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


// define outputs
output defaultHostName string = app.properties.defaultHostName
