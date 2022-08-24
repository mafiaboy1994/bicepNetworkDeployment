targetScope = 'subscription'


@description('parameter array for virtual networks')
param virtualNetworks array

@description('Current Date for deployment records. Do not overwrite!')
param currentDate string = utcNow('yyyy-MM-dd')

@description('Azure region for deployment.')
param location string = deployment().location

param env string

param companyName string

param product string

@description('Dictionary of deployment regions and the shortname')
param locationList object

@description('Custom DNS servers for Virtual Network')
param dnsServers array

var locationShortName = locationList[location]
var groupName = '${product}-${env}'



var tagValues = {
  createdBy: 'AZ CLI'
  environment: env
  deploymentDate: currentDate
  product: product
}



resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'vnets'
  location: location
}


module virtualNetwork './vnet.bicep' =[for vnet in virtualNetworks: {
  scope: resourceGroup
  name: '${vnet.name}-${companyName}-${env}-${locationShortName}-dp'
  params: {
    addressPrefixes: vnet.addressPrefixes
    env: env
    vnetName: '${vnet.name}-${groupName}-${env}-${locationShortName}'
    location: location
    tagValues: tagValues
    locationShortName: locationShortName
    subnets: vnet.subnets
    dnsServers: dnsServers
  }
}]
