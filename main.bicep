targetScope = 'subscription'

// Parameters for common
param systemCode string = 'hawk'
param location string = 'japaneast'
param frontend string = 'frontend'
param backend string = 'backend'

// Parameters for resorce group
param resourceGroupName string = 'rg-${systemCode}'

// Parameters for virtual machine
param adminUsername string = 'azureuser'
param publicIPAllocationMethod string = 'Dynamic'
param publicIpSku string = 'Basic'
param OSVersion string = '2022-datacenter-azure-edition-smalldisk'
param vmSize string = 'Standard_B1s'
param storageAccountType string = 'Standard_LRS'
@minLength(12)
@secure()
param adminPassword string

// Parameters for virtual network
param vnetAddressPrefix string = '10.0.0.0/16'
param snetFrontendName string = 'snet-${frontend}'
param snetFrontendPrefix string = '10.0.1.0/24'
param snetBackendName string = 'snet-${backend}'
param snetBackendPrefix string = '10.0.2.0/24'

// deploy resource groups
resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

// deploy vnet
module vnetModule 'modules/vnet.bicep' = {
  scope: rg
  name: 'Deploy_virtual_network'
  params: {
    location: location
    systemCode: systemCode
    vnetAddressPrefix: vnetAddressPrefix
    snetFrontendName: snetFrontendName
    snetFrontendPrefix: snetFrontendPrefix
    snetBackendName: snetBackendName
    snetBackendPrefix: snetBackendPrefix
    nsgfrontend: nsgModule.outputs.idnsgf
    nsgbackend: nsgModule.outputs.idnsgb
  }
}

// deploy network security group
module nsgModule 'modules/nsg.bicep' = {
  scope: rg
  name: 'Deploy_network_security_group'
  params: {
    location: location
    systemCode: systemCode
    frontend: frontend
    backend: backend
  }
}

// deploy virtual machine
module vmModule 'modules/vm.bicep' = {
  scope: rg
  name: 'Deploy_virtual_machine'
  params: {
    location: location
    systemCode: systemCode
    adminUsername: adminUsername
    publicIPAllocationMethod: publicIPAllocationMethod
    publicIpSku: publicIpSku
    OSVersion: OSVersion
    vmSize: vmSize
    storageAccountType: storageAccountType
    adminPassword: adminPassword
    snetId: vnetModule.outputs.id0
  }
}
