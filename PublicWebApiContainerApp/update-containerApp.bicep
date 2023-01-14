param imageVersionTag string
param rgLocation string = resourceGroup().location

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' existing = {
    name: 'ContainerAppTestACR'
}

resource containerAppEnv 'Microsoft.App/managedEnvironments@2022-06-01-preview' existing = {
    name: 'containerapp-managed-env'
}

var acrServerAddress = containerRegistry.properties.loginServer
var imageName        = '${acrServerAddress}/publicwebapicontainerapp:${imageVersionTag}'
var containerPort    = 8080

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
                targetPort: containerPort
            }
            registries: [
                {
                    server: acrServerAddress
                    identity: 'system'
                }
            ]
        }
        template: {
            containers: [
                {
                    name: 'public-api-app'
                    image: imageName
                    resources: {
                        cpu: json('0.25')
                        memory: '0.5Gi'
                    }
                    env: [
                        {
                            name: 'ASPNETCORE_URLS'
                            value: 'http://+:${containerPort}'
                        }
                    ]
                }
            ]
            scale: {
                minReplicas: 0
                maxReplicas: 3
            }
        }
    }
}

output containerAppFQDN string = containerApp.properties.configuration.ingress.fqdn
