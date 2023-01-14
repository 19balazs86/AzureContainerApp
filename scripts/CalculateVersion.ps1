param(
    [Parameter(Mandatory=$true)]
    [int] $buildId
)

$version = Get-Date -Format "yy.M.d"

$version = -join($version, ".", $buildId)

Write-Host "##vso[task.setvariable variable=version;isOutput=true]$version"