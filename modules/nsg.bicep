@description('System code')
param systemCode string

@description('Location for all resources.')
param location string

@description('Name of the network security group.')
param frontend string
param nsgFrontendName string = 'nsg-${systemCode}-${frontend}'

@description('Name of the network security group.')
param backend string
param nsgBackendName string = 'nsg-${systemCode}-${backend}'

// network security group of frontend subnet.
resource nsgfrontend 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: nsgFrontendName
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-3389'
        properties: {
          priority: 100
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

// network security group of backend subnet.
resource nsgbackend 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: nsgBackendName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowFrontendInbound'
        properties: {
          priority: 100
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '*'
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '10.0.1.0/24'
          destinationAddressPrefix: '*'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowAzureLoadBalancerInBound'
        properties: {
          priority: 110
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '*'
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: '*'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'DenyAllInBound'
        properties: {
          priority: 1000
          access: 'Deny'
          direction: 'Inbound'
          destinationPortRange: '*'
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

@description('Id of frontend nsg')
output idnsgf string = nsgfrontend.id

@description('Id of backend nsg')
output idnsgb string = nsgbackend.id
