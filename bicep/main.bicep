param location string ='westeurope'
param storageAccountName string = 'pawellaunch${uniqueString(resourceGroup().id)}'
param appServiceAppName string = 'pawellaunch${uniqueString(resourceGroup().id)}'

@allowed([
  'nonprod'
  'prod'
])
param environmentType string
var appServicePlanName = 'paweltoyfarm'
var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2v3': 'F1'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
name: storageAccountName
location: location
sku:{
  name: storageAccountSkuName
}
kind:'StorageV2'
properties:{
  accessTier:'Hot'
}
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name:appServicePlanSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceAppName
  location: location
  properties:{
    serverFarmId:appServicePlan.id
    httpsOnly:true
  }
}
