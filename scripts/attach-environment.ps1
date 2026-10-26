#Requires -Version 7.0
# =============================================================================
# Aetherion AirOps - attach to a PRE-PROVISIONED environment (NanoHack)
# -----------------------------------------------------------------------------
# In the NanoHack your facilitator provisions the platform for you. Instead of
# running provision-environment.ps1, run this once. It rebuilds the local state
# file (scripts/.env.aetherion.json) that start-challenge / check-challenge read,
# from the resource group you were assigned. No secrets are handed to you: the
# APIM key is read from your own resource group with your own permissions.
#
# Usage:
#   ./scripts/attach-environment.ps1 -ResourceGroup rg-aetherion-nanohack-07
#   ./scripts/attach-environment.ps1 -ResourceGroup rg-aetherion-nanohack-07 -Force
# =============================================================================
param(
    [Parameter(Mandatory = $true)][string]$ResourceGroup,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$envFile = Join-Path $PSScriptRoot '.env.aetherion.json'
$ns = 'aetherion'

if ((Test-Path $envFile) -and -not $Force) {
    throw "A state file already exists at $envFile. Re-run with -Force to replace it."
}
foreach ($tool in 'az', 'kubectl') {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) { throw "'$tool' is not installed or not on PATH." }
}

$acct = az account show -o json 2>$null | ConvertFrom-Json
if (-not $acct) { throw "Not signed in. Run 'az login' first." }
Write-Host "Subscription: $($acct.name) ($($acct.id))" -ForegroundColor Gray

$rg = az group show --name $ResourceGroup -o json 2>$null | ConvertFrom-Json
if (-not $rg) {
    throw "Resource group '$ResourceGroup' was not found, or you cannot read it. Check the name with your facilitator and that 'az account show' is the right subscription."
}

Write-Host "Reading the deployment outputs from '$ResourceGroup'..." -ForegroundColor Cyan
$depName = az deployment group list -g $ResourceGroup `
    --query "[?starts_with(name,'aetherion-infra-') && properties.provisioningState=='Succeeded'] | sort_by(@,&properties.timestamp) | [-1].name" -o tsv
if ([string]::IsNullOrWhiteSpace($depName)) {
    throw "No successful 'aetherion-infra-*' deployment found in '$ResourceGroup'. Is this the right resource group, and has your facilitator finished provisioning it?"
}
$dep = az deployment group show -g $ResourceGroup -n $depName -o json | ConvertFrom-Json

$namePrefix = if ($dep.properties.parameters.namePrefix.value) { $dep.properties.parameters.namePrefix.value } else { 'aetherion' }
$state = [ordered]@{
    resourceGroup = $ResourceGroup
    location      = $rg.location
    namePrefix    = $namePrefix
}
foreach ($k in $dep.properties.outputs.PSObject.Properties.Name) {
    $state[$k] = $dep.properties.outputs.$k.value
}

Write-Host "Connecting to the AKS cluster..." -ForegroundColor Cyan
az aks get-credentials --resource-group $ResourceGroup --name $state.aksName --overwrite-existing | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Could not get AKS credentials. You need access to the cluster in '$ResourceGroup'." }

$gwIp = kubectl get svc gateway -n $ns -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>$null
if ([string]::IsNullOrWhiteSpace($gwIp)) {
    throw "The 'gateway' service has no public IP yet. The application may not be deployed; tell your facilitator."
}
$state['gatewayIp'] = $gwIp

Write-Host "Reading the APIM subscription key..." -ForegroundColor Cyan
$secretUri = "https://management.azure.com/subscriptions/$($acct.id)/resourceGroups/$ResourceGroup/providers/Microsoft.ApiManagement/service/$($state.apimName)/subscriptions/aetherion-ops-sub/listSecrets?api-version=2022-08-01"
$apiKey = az rest --method post --uri $secretUri --query primaryKey -o tsv 2>$null
if ([string]::IsNullOrWhiteSpace($apiKey)) { throw "Could not read the APIM key. You need Contributor or Owner on '$ResourceGroup'." }
$state['apimSubscriptionKey'] = $apiKey

# HTTPS is optional: only present if the facilitator ran the HTTPS step.
$host_ = kubectl get httproute gateway-route -n $ns -o jsonpath='{.spec.hostnames[0]}' 2>$null
if (-not [string]::IsNullOrWhiteSpace($host_)) {
    $state['gatewayFqdn'] = $host_
    $state['httpsUrl'] = "https://$host_/"
}

# Start/stop of the load generator creates "<rg>-loadgen"; warn early if it is not writable.
$lg = "$ResourceGroup-loadgen"
if ((az group exists --name $lg) -ne 'true') {
    Write-Host "  WARNING: load-generator resource group '$lg' not found or not visible to you." -ForegroundColor Yellow
    Write-Host "  start-challenge needs Contributor on it. Tell your facilitator." -ForegroundColor Yellow
}

$state | ConvertTo-Json -Depth 5 | Set-Content -Path $envFile -Encoding UTF8
Write-Host ""
Write-Host "Attached. State saved to $envFile (git-ignored; do not share it)." -ForegroundColor Green
Write-Host "  Resource group: $ResourceGroup" -ForegroundColor Gray
Write-Host "  AKS:            $($state.aksName)" -ForegroundColor Gray
Write-Host "  Ops Center:     $(if ($state.httpsUrl) { $state.httpsUrl } else { "http://$gwIp/" })" -ForegroundColor Gray
Write-Host "  Grafana:        $($state.grafanaEndpoint)" -ForegroundColor Gray
Write-Host ""
Write-Host "Next: ./scripts/start-challenge.ps1 1" -ForegroundColor Cyan
