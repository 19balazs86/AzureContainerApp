# Deploy Azure Container Apps with the az containerapp up command
# https://learn.microsoft.com/en-us/azure/container-apps/containerapp-up

# I run it manually for test. Not used in the pipeline.

# This command creates a resource group, an environment, a LogAnalytics and the containerapp

az containerapp up \
  --name 'helloworld-container-app' \
  --image 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest' \
  --resource-group 'rg-container-app-up' \
  --environment 'containerapp-managed-env-test' \
  --ingress external \
  --target-port 80