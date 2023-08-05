param location string = 'canadacentral'
param appName string = 'beeskneewebapp'
param httpdContainerImage string = 'chumaigwe9/bees-knee-web:1.0'

/*
------------------------------------------------
CONTAINER INSTANCE 1
------------------------------------------------
*/
module httpdContainer1 './modules/httpdContainer.bicep' = {
  name: '${appName}-container1'
  params: {
    containerImage: httpdContainerImage
    location: location
  }
}

/*
------------------------------------------------
CONTAINER INSTANCE 2
------------------------------------------------
*/
module httpdContainer2 './modules/httpdContainer.bicep' = {
  name: '${appName}-container2'
  params: {
    containerImage: httpdContainerImage
    location: location
  }
}

/*
------------------------------------------------
APPLICATION GATEWAY
------------------------------------------------
*/
// module appGateway './modules/appGateway.bicep' = {
//   name: '${appName}-appgateway'
//   params: {
//     frontendPort: 80
//     backendPort: 80
//     httpdContainer1Id: httpdContainer1.outputs.containerInstanceId
//     httpdContainer2Id: httpdContainer2.outputs.containerInstanceId
//     location: location
//     appName: appName
//   }
// }
