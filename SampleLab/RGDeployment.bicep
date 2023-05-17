targetScope = 'subscription'

param labName string
param expiryDate string
param location string = 'East US'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${labName}-rg'
  location: location
  tags: {
    ExpiryDate: expiryDate
    Purpose: 'Environment for ${labName}'
  }
}

module deployment './ResourcesDeployment.bicep' = {
  name: 'storageDeploy'
  params: {
    labName: labName
    location: rg.location
  }
  scope: resourceGroup(rg.name)
}
