param labName string
param location string = 'East US'
param workVmCount int = 4

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: '${labName}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.20.0.0/16'
      ]
    }
    subnets: [
      {
        name: '${labName}-service-subnet'
        properties: {
          addressPrefix: '172.20.0.0/24'
        }
      }
      {
        name: '${labName}-work-subnet'
        properties: {
          addressPrefix: '172.20.2.0/24'
        }
      }
    ]
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  name: '${labName}-nsg'
  location: location
  dependsOn: [
    vnet
  ]
  properties: {
    securityRules: []
  }
}

module factoryioMachine 'Resources/ServiceVM.bicep' = {
  name: '${labName}-factoryioMachine'
  params: {
    labName: labName
    subnetId: vnet.properties.subnets[0].id
    location: location
    nsgId: networkSecurityGroup.id
  }
}

module workMachines 'Resources/WorkVM.bicep' = [for i in range(0, workVmCount): {
  name: '${labName}-workMachine_${i}'
  params: {
    labName: labName
    subnetId: vnet.properties.subnets[0].id
    location: location
    nsgId: networkSecurityGroup.id
    vmName: 'workVM-${i}'
  }
}]
