# Install-Module -Name Az.App

# I run it manually. Not used in the pipeline.

$env = @{
    Name = 'TestKey1'
    Value = 'TestValue1'
}

$imageParams = @{
    Name = 'public-api-app'
    Image = 'containerapptestacr.azurecr.io/publicwebapicontainerapp:latest'
    ResourceCpu = 0.25
    ResourceMemory = '0.5Gi'
    Env = $env
}

# https://learn.microsoft.com/en-us/powershell/module/az.app/new-azcontainerapptemplateobject

$templateObj = New-AzContainerAppTemplateObject @imageParams

$updateArgs = @{
    Name = 'containerapp-public-api'
    ResourceGroupName = 'ContainerAppTest-ResGroup'
    Location = 'North Europe'
    TemplateContainer = $templateObj
}

# https://learn.microsoft.com/en-us/powershell/module/az.app/update-azcontainerapp

Update-AzContainerApp @updateArgs