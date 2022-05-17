@description('Globally unique server name')
param serverName string

resource server 'Microsoft.Sql/servers@2021-11-01-preview' existing = {
  name: serverName  
}

resource allowAllAzureIps 'Microsoft.Sql/servers/firewallRules@2021-11-01-preview' = {
  parent: server
  name: 'AllowAllAzureIps'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource allowClientIps 'Microsoft.Sql/servers/firewallRules@2021-11-01-preview' = {
  parent: server
  name: 'AllowClientIps'
  properties: {
    startIpAddress: '219.88.235.68'
    endIpAddress: '219.88.235.68'
  }
}
