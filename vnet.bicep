param vnetName string

@description('Azure region for deployment.')
param location string

param env string

param tagValues object

param addressPrefixes array

param dnsServers array

@description('Short name for the deployment region')
param locationShortName string

var dnsServers_var = {
  dnsServers: array(dnsServers)
}


param subnets array

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetName
  location: location
  tags: tagValues
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    dhcpOptions: !empty(dnsServers) ? dnsServers_var : null
    subnets: [for subnet in subnets: {
      name: 'snet-${subnet.name}-${env}-${locationShortName}'
      properties: {
        addressPrefix: subnet.subnetPrefix
      }
    }]
  }
}
