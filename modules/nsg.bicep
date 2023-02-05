@description('Location for all resources.')
param location string

@description('System code')
param systemCode string

@description('Environment')
param env string

@description('Name of the network security group.')
param frontend string
param nsgFrontendName string = 'nsg-${systemCode}-${env}-${frontend}'

@description('Name of the network security group.')
param backend string
param nsgBackendName string = 'nsg-${systemCode}-${env}-${backend}'

// network security group of frontend subnet.
resource nsgfrontend 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: nsgFrontendName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowRDPInbound'
        properties: {
          priority: 100
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRange: '3389'
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
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '10.0.1.0/24'
          destinationPortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'AllowAzureLoadBalancerInBound'
        properties: {
          priority: 110
          access: 'Allow'
          direction: 'Inbound'
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationPortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'DenyAllInBound'
        properties: {
          priority: 1000
          access: 'Deny'
          direction: 'Inbound'
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

@description('Id of frontend nsg')
output idnsgf string = nsgfrontend.id

@description('Id of backend nsg')
output idnsgb string = nsgbackend.id
