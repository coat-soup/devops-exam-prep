// File: main.bicep

param location string
param containerRegistryName string
param servicePlanName string
param webAppName string
param containerRegistryImageName string
param containerRegistryImageVersion string
param containerRegistryUsername string
param containerRegistryPassword string

module containerRegistry 'modules/acr.bicep' = {
  name: 'containerRegistryDeployment'
  params: {
    name: containerRegistryName
    location: resourceGroup().location
    acrAdminUserEnabled: true
  }
}

module servicePlan 'modules/asp.bicep' = {
  name: 'linuxServicePlanDeployment'
  params: {
    name: servicePlanName
    location: location
    sku: {
      capacity: 1
      family: 'B'
      name: 'B1'
      size: 'B1'
      tier: 'Basic'
    }
    kind: 'Linux'
  }
}

module webApp 'modules/app.bicep' = {
  name: 'webAppDeployment'
  params: {
    name: webAppName
    location: location
    kind: 'app'
    serverFarmResourceId: resourceId('Microsoft.Web/serverfarms', servicePlan.name)
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistryName}.azurecr.io/${containerRegistryImageName}:${containerRegistryImageVersion}'
      appCommandLine: ''
    }
    appSettingsKeyValuePairs: {
      WEBSITES_ENABLE_APP_SERVICE_STORAGE: false
      DOCKER_REGISTRY_SERVER_URL: 'https://${containerRegistryName}.azurecr.io'
      DOCKER_REGISTRY_SERVER_USERNAME: containerRegistryUsername
      DOCKER_REGISTRY_SERVER_PASSWORD: containerRegistryPassword
    }
  }
}

