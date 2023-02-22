# Deploy Azure Function App using Bicep and GitHub Actions

This example shows how to deploy a Azure Function App using [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview) and [GitHub Actions](https://github.com/features/actions).

## Prerequisites

* An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/free/).
* A GitHub account. If you don't have one, sign up for [free](https://github.com/join).
* [PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows) > 6.2
* [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
* [GitHub CLI](https://cli.github.com)

## Set up repo

* For the example fork the current repository.
* Ensure Actions is enabled for your repository. Navigate to your forked repository and select **Settings > Actions**. In **Actions permissions**, ensure that **Allow all actions** is selected.
* Ensure you are logged in within the Azure CLI and the GitHub CLI.

## Create resources

Run the `scripts\setup.ps1` script to create all required Azure resources using the [infrastructure-as-code](https://learn.microsoft.com/en-us/devops/deliver/what-is-infrastructure-as-code) Bicep file `infra\main.bicep` and to setup required [GitHub secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets).

**Note:** In the `scripts\variables.ps1` file you can adjust the resources location and names.

## Validate resources

In the [Azure Portal](https://portal.azure.com), navigate to the **Resource groups** and check if the resource group and it's resources have been created:

1. Select the **Function App** `func-<GUID>`.
2. Select the function app's **Overview page**.
3. Click on the URL link (`https://func-<GUID>.azurewebsites.net`) to check if the Function App is running.

In [GitHub](https://github.com), go to your repository and navigate to **Settings > Secrets and variables > Actions** and check if the secrets `AZURE_RBAC_CREDENTIALS` and `FUNCTION_APP_NAME` have been created.

## Run GitHub Actions workflow

1. In [GitHub](https://github.com), go to your repository.
2. Select **Actions > Workflows**.
3. Select **Deploy Function App Code** Workflow.
4. Click **Run workflow**.

## Validate deployment

When the workflow completes successfully, navigate in the [Azure Portal](https://portal.azure.com) to the **Function App**:

1. Select the function app's **Overview page**.
2. Click on the URL link (`https://func-<GUID>.azurewebsites.net`) to check if the Function App is running.
3. Call the Function App endpoint `https://func-<GUID>.azurewebsites.net/api/Function`.
4. The text `This HTTP triggered function executed successfully (Code)` should be displayed.

**Note**: Via the link `https://func-<GUID>.scm.azurewebsites.net` you can access the [Kudu Service](https://learn.microsoft.com/en-us/azure/app-service/resources-kudu) for the Function App.

## Clean up resources

Run the `scripts\cleanup.ps1` script to delete Azure resources and GitHub secrets.

## Additional resources

* [Continuous delivery by using GitHub Actions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-how-to-github-actions)
* [GitHub Actions for deploying to Azure Functions](https://github.com/Azure/functions-action)