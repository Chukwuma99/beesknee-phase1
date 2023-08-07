param containerImage string
param location string
param appName string

resource containerInstance1 'Microsoft.ContainerInstance/containerGroups@2021-07-01' = {
  name: '${location}-${guid(containerImage)}-1'
  location: location
  properties: {
    containers: [
      {
        name: 'httpd-container-1'
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

resource containerInstance2 'Microsoft.ContainerInstance/containerGroups@2021-07-01' = {
  name: '${location}-${guid(containerImage)}-2'
  location: location
  properties: {
    containers: [
      {
        name: 'httpd-container-2'
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

output containerInstanceFqdn1 string = '${containerInstance1.name}.${location}.azurecontainer.io'
output containerInstanceFqdn2 string = '${containerInstance2.name}.${location}.azurecontainer.io'
