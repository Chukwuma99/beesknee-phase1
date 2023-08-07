param appName string = 'beeskneewebapp'
param location string = 'canadacentral'
param image string = 'chumaigwe9/bees-knee-web:1.0'

// public IP address
resource publicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: '${appName}PublicIP'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
}

// virtual network and subnet for the application gateway
resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: '${appName}Vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: '${appName}Subnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

// Application Gateway
resource appGateway 'Microsoft.Network/applicationGateways@2021-02-01' = {
  name: '${appName}AppGateway'
  location: location
  properties: {
    sku: {
      name: 'Standard_v2'
      tier: 'Standard_v2'
      capacity: 2
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: vnet.properties.subnets[0].id
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGatewayFrontendIp'
        properties: {
          publicIPAddress: {
            id: publicIP.id
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'appGatewayFrontendPort'
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'appGatewayBackendPool'
        properties: {
          backendAddresses: [
            {
              ipAddress: 'container1IpAddress'
            }
            {
              ipAddress: 'container2IpAddress'
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'appGatewayBackendHttpSettings'
        properties: {
          port: 80
          protocol: 'Http'
        }
      }
    ]
    httpListeners: [
      {
        name: 'appGatewayHttpListener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', '${appName}AppGateway', 'appGatewayFrontendIp')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', '${appName}AppGateway', 'appGatewayFrontendPort')
          }
          protocol: 'Http'
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'rule1'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', '${appName}AppGateway', 'appGatewayHttpListener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', '${appName}AppGateway', 'appGatewayBackendPool')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', '${appName}AppGateway', 'appGatewayBackendHttpSettings')
          }
        }
      }
    ]
  }
}


// container 1
resource containerGroup1 'Microsoft.ContainerInstance/containerGroups@2021-03-01' = {
  name: '${appName}ContainerGroup1'
  location: location
  properties: {
    containers: [
      {
        name: 'container1'
        properties: {
          image: image
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 1
            }
          }
          ports: [
            {
              port: 80
            }
          ]
        }
      }
    ]
    restartPolicy: 'Always'
    ipAddress: {
      type: 'Public'
      ports: [
        {
          protocol: 'tcp'
          port: 80
        }
      ]
    }
    osType: 'Linux'
  }
}

// container 2
resource containerGroup2 'Microsoft.ContainerInstance/containerGroups@2021-03-01' = {
  name: '${appName}ContainerGroup2'
  location: location
  properties: {
    containers: [
      {
        name: 'container2'
        properties: {
          image: image
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 1
            }
          }
          ports: [
            {
              port: 80
            }
          ]
        }
      }
    ]
    restartPolicy: 'Always'
    ipAddress: {
      type: 'Public'
      ports: [
        {
          protocol: 'tcp'
          port: 80
        }
      ]
    }
    osType: 'Linux'
  }
}

output appGatewayPublicIp string = publicIP.properties.ipAddress
output containerGroup1IP string = containerGroup1.properties.ipAddress.ip
output containerGroup2IP string = containerGroup2.properties.ipAddress.ip
