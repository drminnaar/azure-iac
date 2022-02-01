//
// define scope
//
targetScope = 'subscription'


//
// define parameters
//
@description('The name of app')
var websiteName = 'dotnethelloworld'

@description('The name of resource group')
var rgName = '${websiteName}-rg'

@description('The location of all resources')
var location = deployment().location

@description('The source of web app that will be deployed')
var repoUrl = 'https://github.com/drminnaar/demowebapp-dotnet.git'


//
// define resources
//
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}


//
// define modules
//
module appService 'modules/appservice.bicep' = {
  scope: resourceGroup
  name: '${websiteName}-${uniqueString(resourceGroup.id)}-deployment'
  params: {
    websiteName: websiteName
    repoUrl: repoUrl
  }
}


//
// define outputs
//
output defaultHostName string = appService.outputs.defaultHostName
