@description('Globally unique server name')
param serverName string

@description('Server and Database location')
param location string

@allowed([
  'Enabled'
  'Disabled'
])
@description('Whether or not public endpoint access is allowed for this server. Value is optional but if passed in, must be "Enabled" or "Disabled"')
param publicNetworkAccess string = 'Disabled'

@allowed([
  'Enabled'
  'Disabled'
])
@description('Whether or not public endpoint access is allowed for this server. Value is optional but if passed in, must be "Enabled" or "Disabled"')
param restrictOutboundNetworkAccess string = 'Disabled'

@secure()
@description('Administrator username for the server. Once created it cannot be changed.')
param administratorLogin string

@secure()
@description('The administrator login password (required for server creation)')
param administratorLoginPassword string

resource server 'Microsoft.Sql/servers@2021-11-01-preview' = {
  name: serverName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    publicNetworkAccess: publicNetworkAccess
    restrictOutboundNetworkAccess: restrictOutboundNetworkAccess
    version: '12.0'
  }
}
