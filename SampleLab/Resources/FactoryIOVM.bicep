param labName string
param location string = resourceGroup().location
param subnetId string
param nsgId string
//output subnetName string = '${subnetName}'

resource networkInterface 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  name: '${labName}-factoryio-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
    networkSecurityGroup: {
      location: location
      id: nsgId
    }
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: '${labName}-factoryio'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
    osProfile: {
      computerName: '${labName}-factoryio'
      adminUsername: 'adminaccount'
      adminPassword: 'P@ssw0rd1234'
    }
  }
}
