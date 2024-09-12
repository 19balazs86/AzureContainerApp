@minLength(5)
param appName string

var rgLocation = resourceGroup().location

var webApiName = 'web-api'
var echoServerName = 'echo-server'

// --> Container Registry
// https://learn.microsoft.com/en-us/azure/templates/microsoft.containerregistry/registries

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: '${appName}CR'
  location: rgLocation
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: false
  }
}

// --> User Assigned - Managed Identity
// https://learn.microsoft.com/en-us/azure/templates/microsoft.managedidentity/userassignedidentities

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: '${appName}-ID'
  location: rgLocation
}

// --> Role assignment
// https://learn.microsoft.com/en-us/azure/templates/microsoft.authorization/roleassignments
// https://yourazurecoach.com/2023/02/02/my-developer-friendly-bicep-module-for-role-assignments

var acrPullRoleId = '7f951dda-4ed3-4680-a7ca-43fe172d538d'

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, userAssignedIdentity.id, 'AcrPull')
  scope: containerRegistry
  properties: {
    principalId: userAssignedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', acrPullRoleId)
  }
}

// // --> LogAnalytics workspace
// // https://learn.microsoft.com/en-us/azure/templates/microsoft.operationalinsights/workspaces

// resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
//   name: '${appName}-LOG'
//   location: rgLocation
//   properties: {
//     retentionInDays: 30
//     sku: {
//       name: 'PerGB2018'
//     }
//   }
// }

// // --> Application Insights
// // https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/components

// resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
//   name: '${appName}-APPI'
//   location: rgLocation
//   kind: 'web'
//   properties: {
//     Application_Type: 'web'
//     WorkspaceResourceId: logAnalytics.id
//   }
// }

// --> Conainer App - Managed Environments
// https://learn.microsoft.com/en-us/azure/templates/microsoft.app/managedenvironments

resource containerAppEnv 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: '${appName}-CAE'
  location: rgLocation
  properties: {
    // daprAIConnectionString: applicationInsights.properties.ConnectionString
    // appLogsConfiguration: {
    //   destination: 'log-analytics'
    //   logAnalyticsConfiguration: {
    //     customerId: logAnalytics.properties.customerId
    //     sharedKey: logAnalytics.listKeys().primarySharedKey
    //   }
    // }
  }
}

// --> Container App: Echo-Server
// https://learn.microsoft.com/en-us/azure/templates/microsoft.app/containerapps

resource echoContainerApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: echoServerName
  location: rgLocation
  properties: {
    managedEnvironmentId: containerAppEnv.id
    configuration: {
      maxInactiveRevisions: 5
      ingress: {
        external: true
        targetPort: 8080
      }
      dapr: {
        enabled: true
        appId: echoServerName
        appProtocol: 'http'
        appPort: 8080
        enableApiLogging: true
      }
      secrets: [
        {
          name: 'simple-secret'
          value: 'My simple secret value'
        }
        // {
        //   name: 'kv-secret' // You can use it with secretRef in env variables
        //   // You can find this URL by navigating to KV, selecting a secret, opening the current revision, and copying the value from the 'Secret Identifier' field
        //   keyVaultUrl: 'https://KeyVaultName.vault.azure.net/secrets/MyConnectionString/GUID'
        //   // This is the userAssignedIdentity.id value (Resource ID)
        //   identity: '/subscriptions/<GUID>/resourcegroups/<ResGroupName>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<MyIdentityName>'
        // }
      ]
    }
    template: {
      containers: [
        {
          name: echoServerName
          image: 'mendhak/http-https-echo:latest'
          resources: {
            cpu: json('0.25')
            memory: '0.5Gi'
          }
          env: [
            {
              name: 'env-simple-secret'
              secretRef: 'simple-secret'
            }
          ]
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 1
      }
    }
  }
}

// --> Container App: Web-Api
// https://learn.microsoft.com/en-us/azure/templates/microsoft.app/containerapps

resource webApiContainerApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: webApiName
  location: rgLocation
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentity.id}': {}
    }
  }
  properties: {
    managedEnvironmentId: containerAppEnv.id
    configuration: {
      maxInactiveRevisions: 5
      registries: [
        {
          server: containerRegistry.properties.loginServer
          identity: userAssignedIdentity.id
        }
      ]
      ingress: {
        external: true
        targetPort: 8080
      }
      dapr: {
        enabled: true
        appId: webApiName
        appProtocol: 'http'
        appPort: 8080
        enableApiLogging: true
      }
    }
    template: {
      containers: [
        {
          name: webApiName
          image: 'mcr.microsoft.com/dotnet/samples:aspnetapp-chiseled' // First, use a sample image, the pipeline will apply a new image
          resources: {
            cpu: json('0.25')
            memory: '0.5Gi'
          }
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 2
        rules: [
          {
            name: 'rule-http'
            http: {
              metadata: {
                concurrentRequests: '15'
              }
            }
          }
        ]
      }
    }
  }
}

output WebApiContainerAppFQDN string = webApiContainerApp.properties.configuration.ingress.fqdn
output EchoContainerAppFQDN string   = echoContainerApp.properties.configuration.ingress.fqdn
