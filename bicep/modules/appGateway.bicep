param location string
param backendAddresses array

resource publicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: 'beeskneePublicIP'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
}


resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'beeskneeVnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'beeskneeSubnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

resource appGateway 'Microsoft.Network/applicationGateways@2021-02-01' = {
  name: 'beeskneeAppGateway'
  location: location
  properties: {
    sku: {
      name: 'Standard_Small'
      tier: 'Standard'
      capacity: 2
    }
    gatewayIPConfigurations: [
      {
        name: 'beeskneeGatewayIP'
        properties: {
          subnet: {
            id: vnet.properties.subnets[0].id
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'beeskneeFrontendIP'
        properties: {
          publicIPAddress: {
            id: publicIP.id
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'beeskneePort'
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'beeskneeBackendPool'
        properties: {
          backendAddresses: [for address in backendAddresses: {
            ipAddress: address
          }]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'beeskneeBackendHttpSettings'
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          requestTimeout: 20
        }
      }
    ]
    httpListeners: [
      {
        name: 'beeskneeHttpListener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', 'beeskneeAppGateway', 'beeskneeFrontendIP')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', 'beeskneeAppGateway', 'beeskneePort')
          }
          protocol: 'Http'
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'beeskneeRequestRoutingRule'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', 'beeskneeAppGateway', 'beeskneeHttpListener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', 'beeskneeAppGateway', 'beeskneeBackendPool')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', 'beeskneeAppGateway', 'beeskneeBackendHttpSettings')
          }
        }
      }
    ]
  }
}
