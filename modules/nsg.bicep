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

param nsgValues object = {
  nsg1: {
    name: nsgFrontendName
    location: location
    properties: {
      securityRules: [
        {
          name: 'AllowRDPInBound'
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
  nsg2: {
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
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-06-01' = [for nsg in items(nsgValues): {
  name: nsg.value.name
  location: nsg.value.location
  properties: {
    securityRules: [
      {
        name: nsg.value.name
        properties: {
          priority: nsg.value.priority
          access: nsg.value.access
          direction: nsg.value.direction
          protocol: nsg.value.protocol
          sourcePortRange: nsg.value.sourcePortRange
          sourceAddressPrefix: nsg.value.sourceAddressPrefix
          destinationPortRange: nsg.value.destinationPortRange
          destinationAddressPrefix: nsg.value.destinationAddressPrefix
        }
      }
    ]
  }
}]

@description('Id of frontend nsg')
output idnsgf string = nsg[0].id

@description('Id of backend nsg')
output idnsgb string = nsg[1].id
