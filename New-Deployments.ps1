param (
    [Parameter()]
    [string]$deploymentName = "deploy-$(Get-Date -Format 'yyyyMMddHHmmss')",
    [Parameter()]
    [string]$location = "canadacentral",
    [Parameter()]
    [string]$templateFile = "infra/main.bicep",
    [Parameter()]
    [string]$nameSuffix = "ek001"
)

az deployment sub create --name $deploymentName `
    --location "$location" `
    --template-file $templateFile `
    --parameters name="$nameSuffix"