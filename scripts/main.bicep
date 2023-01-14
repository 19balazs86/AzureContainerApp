param rgLocation string = resourceGroup().location

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
    name: 'ContainerAppTestACR'
    location: rgLocation
    sku: {
        name: 'Basic'
    }
    properties: {
        adminUserEnabled: false
    }
}

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
    name: 'containerapp-log-analytics'
    location: rgLocation
    properties: {
        retentionInDays: 30
        sku: {
            name: 'PerGB2018'
        }
    }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
    name: 'containerapp-appInsights'
    location: rgLocation
    kind: 'web'
    properties: {
        Application_Type: 'web'
        WorkspaceResourceId: logAnalytics.id
    }
}

resource containerAppEnv 'Microsoft.App/managedEnvironments@2022-06-01-preview' = {
    name: 'containerapp-managed-env'
    location: rgLocation
    properties: {
        daprAIInstrumentationKey: applicationInsights.properties.InstrumentationKey
        appLogsConfiguration: {
            destination: 'log-analytics'
            logAnalyticsConfiguration: {
                customerId: logAnalytics.properties.customerId
                sharedKey: logAnalytics.listKeys().primarySharedKey
            }
        }
    }
}

// https://learn.microsoft.com/en-us/azure/templates/microsoft.app/containerapps?pivots=deployment-language-bicep

// I am using SystemAssigned identity. The container needs to be created with a public image.
// The pipeline will update it with an image from ARC

resource containerApp 'Microsoft.App/containerApps@2022-06-01-preview' = {
    name: 'containerapp-public-api'
    location: rgLocation
    identity: {
        type: 'SystemAssigned'
    }
    properties: {
        managedEnvironmentId: containerAppEnv.id
        configuration: {
            ingress: {
                external: true
                targetPort: 80
            }
        }
        template: {
            containers: [
                {
                    name: 'simple-hello-world'
                    image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
                    resources: {
                        cpu: json('0.25')
                        memory: '0.5Gi'
                    }
                    env: [
                        {
                            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
                            value: applicationInsights.properties.ConnectionString
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

var acrPullRoleId = '7f951dda-4ed3-4680-a7ca-43fe172d538d'

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
    name: guid(resourceGroup().id, containerRegistry.id, 'AcrPullSystemAssigned')
    scope: containerRegistry
    properties: {
        principalId: containerApp.identity.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', acrPullRoleId)
    }
}

resource echoContainerApp 'Microsoft.App/containerApps@2022-06-01-preview' = {
    name: 'echo-server'
    location: rgLocation
    properties: {
        managedEnvironmentId: containerAppEnv.id
        configuration: {
            ingress: {
                external: true
                targetPort: 80
            }
            dapr: {
                enabled: true
                appId: 'echo-server'
                appProtocol: 'http'
                appPort: 80
            }
        }
        template: {
            containers: [
                {
                    name: 'simple-echo-server'
                    image: 'mendhak/http-https-echo:latest'
                    resources: {
                        cpu: json('0.25')
                        memory: '0.5Gi'
                    }
                }
            ]
            scale: {
                minReplicas: 0
                maxReplicas: 1
            }
        }
    }
}

output containerAppFQDN string = containerApp.properties.configuration.ingress.fqdn
output echoContainerAppFQDN string = echoContainerApp.properties.configuration.ingress.fqdn
