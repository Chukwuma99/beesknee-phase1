param location string
param dnsNameLabel string

param imageName string = 'chumaigwe9/bees-knee-web:1.0'

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2023-05-01' = {
  name: dnsNameLabel
  location: location
  properties: {
    containers: [
      {
        name: dnsNameLabel
        properties: {
          image: imageName
          ports: [
            {
              port: 80
            }
          ]
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 1
            }
          }
        }
      }
    ]
    restartPolicy: 'Always'
    ipAddress: {
      type: 'Public'
      dnsNameLabel: dnsNameLabel
      ports: [
        {
          protocol: 'TCP'
          port: 80
        }
      ]
    }
    osType: 'Linux'
  }
}

output ipAddress string = containerGroup.properties.ipAddress.ip
