#!/bin/bash

# https://learn.microsoft.com/en-us/cli/azure/deployment/group?view=azure-cli-latest#az-deployment-group-create

az deployment group create \
    --name "Main-Deployment" \
    --resource-group "ContainerAppTest-ResGroup" \
    --template-file "main.bicep" \
    --parameters "@main.parameters.json"