@description('System code')
param systemCode string

@description('Location for all resources.')
param location string

@description('VNet name')
param vnetName string = 'vnet-${systemCode}'

@description('Virtual network address prefix')
param vnetAddressPrefix string

@description('Subnet properties')
param snetFrontendName string
param snetFrontendPrefix string
param snetBackendName string
param snetBackendPrefix string
param nsgfrontend string
param nsgbackend string

param subnets array = [
  {
    name: snetFrontendName
    subnetPrefix: snetFrontendPrefix
    id: nsgfrontend
  }
  {
    name: snetBackendName
    subnetPrefix: snetBackendPrefix
    id: nsgbackend
  }
]

var subnetsProperty = [for subnet in subnets: {
  name: subnet.name
  properties: {
    addressPrefix: subnet.subnetPrefix
    networkSecurityGroup: {
      id: subnet.id
    }
  }
}]

// deploy virtual network.
resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: subnetsProperty
  }
}

@description('Id of frontend subnet')
output id0 string = vnet.properties.subnets[0].id

@description('Id of backend subnet')
output id1 string = vnet.properties.subnets[1].id
