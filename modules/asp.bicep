// File: modules/servicePlan.bicep

param name string
param location string
param sku object
param kind string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: name
  location: location
  sku: {
    name: sku.name
    capacity: sku.capacity
    tier: sku.tier
  }
  kind : kind
  properties: {
    reserved: true // This makes it a Linux App Service Plan
  }
}

output servicePlanId string = appServicePlan.id
