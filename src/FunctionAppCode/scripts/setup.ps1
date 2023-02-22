Clear-Host
. ".\variables.ps1"

Write-LogInfo "Create Resource Group..."
az group create `
    --name $RESOURCE_GROUP_NAME `
    --location $LOCATION `
    --output none

Test-ExitCode

Write-LogInfo "`nCreate Infrastructure..."
az deployment group create `
    --name FuncAppCodeDeployment `
    --resource-group $RESOURCE_GROUP_NAME `
    --template-file ../infra/main.bicep `
    --parameters location=$LOCATION `
    --output none

Test-ExitCode

Write-LogInfo "`nGet Function App ID..."
$FUNCTION_APP_ID = az functionapp list `
    --resource-group $RESOURCE_GROUP_NAME `
    --query "[].id" `
    --output tsv

Test-ExitCode

Write-LogInfo "`nCreate Service Principal For RBAC..."
$SERVICE_PRINCIPAL_JSON = az ad sp create-for-rbac `
    --name $SERVICE_PRINCIPAL_NAME `
    --scopes $FUNCTION_APP_ID `
    --role Contributor `
    --sdk-auth

Test-ExitCode

# Set Service Principal Variables
$SERVICE_PRINCIPAL_JSON_OBJ = $SERVICE_PRINCIPAL_JSON | ConvertFrom-Json
$SERVICE_PRINCIPAL_JSON_STR = $SERVICE_PRINCIPAL_JSON_OBJ | ConvertTo-Json -EscapeHandling EscapeHtml

Write-LogInfo "`nGet Function App Name..."
$FUNCTION_APP_NAME = az functionapp list `
    --resource-group $RESOURCE_GROUP_NAME `
    --query "[].name" `
    --output tsv

Test-ExitCode

Write-LogInfo "`nSet GitHub Repository Secrets..."
gh secret set AZURE_RBAC_CREDENTIALS --body "$SERVICE_PRINCIPAL_JSON_STR"
gh secret set FUNCTION_APP_NAME --body "$FUNCTION_APP_NAME"

Write-LogInfo("`nSetup Complete")