# Install the Azure PowerShell module
# https://docs.microsoft.com/en-us/powershell/azure/install-az-ps

# Sign in
# Connect-AzAccount

param(
    [string] $resGroupName = "ContainerAppTest-ResGroup",
    [string] $location     = "North Europe",
    [string] $acrName      = "ContainerAppTestACR",
    [string] $sku          = "Basic"
)

# --> Create: ResourceGroup
Get-AzResourceGroup -Name $resGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue | Out-Null

if ($notPresent)
{
    Write-Host "Creating resource group..."

    New-AzResourceGroup -Name $resGroupName -Location $location
}
else
{
    Write-Host "Already exists:" $resGroupName
}

# --> Create: ContainerRegistry
Get-AzContainerRegistry `
    -ResourceGroupName $resGroupName `
    -Name $acrName `
    -ErrorVariable notPresent `
    -ErrorAction SilentlyContinue | Out-Null

if ($notPresent)
{
    Write-Host "Creating container registry..."

    New-AzContainerRegistry -ResourceGroupName $resGroupName -Name $acrName -Sku $sku -EnableAdminUser
}
else
{
    Write-Host "Already exists:" $acrName
}