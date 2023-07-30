targetScope = 'resourceGroup'

param resourceGroupName string = 'iacBeesKneeRG'
param location string = 'canadacentral'
param dnsNameLabel string = 'beesknee'

module containerGroup1 './modules/containerGroup.bicep' = {
  name: '${dnsNameLabel}1'
  params: {
    location: location
    dnsNameLabel: '${dnsNameLabel}1'
  }
}

module containerGroup2 './modules/containerGroup.bicep' = {
  name: '${dnsNameLabel}2'
  params: {
    location: location
    dnsNameLabel: '${dnsNameLabel}2'
  }
}

module appGateway './modules/appGateway.bicep' = {
  name: '${dnsNameLabel}AppGateway'
  params: {
    location: location
    backendAddresses: [
      containerGroup1.outputs.ipAddress
      containerGroup2.outputs.ipAddress
    ]
  }
}
