param containerImage string
param location string

resource containerInstance 'Microsoft.ContainerInstance/containerGroups@2021-07-01' = {
  name: '${location}-${guid(containerImage)}'
  location: location
  properties: {
    containers: [
      {
        name: 'httpd-container'
        properties: {
          image: containerImage
          ports: [
            {
              port: 80
              protocol: 'TCP'
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
    osType: 'Linux'
    restartPolicy: 'Always'
  }
}

output containerInstanceId string = containerInstance.id
