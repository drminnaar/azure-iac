![Azure IaC](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/vuhr8y4uj1ppa72kj9h7.png)

# Azure Infrastructure as Code (IaC)

A collection of Azure IaC examples demonstrating Azure CLI, Azure Powershell and Bicep.

---

## Other Resources

### Official Examples

The [official Azure Bicep Github repository](https://github.com/Azure/bicep/tree/main/docs/examples) has a compilation of examples.

### Bicep Playground

Try the [Bicep Playground](https://aka.ms/bicepdemo) to experiment with and lear Azure Bicep

---

## Tools

- [Installation and Docs](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install)

  Everything you need to install and configure your windows, linux, and macos environment

- [Official Bicep Visual Studio Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)

  Provides Bicep language support

- [JQ](https://stedolan.github.io/jq/)

  jq is a lightweight and flexible command-line JSON processor

- [Azure Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-node-azure-pack)

  A package of all the Visual Studio Code extensions that you will need to work with Azure

- [Azure CLI Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.azurecli)

  Tools for developing and running commands of the Azure CLI

- [Azure Function Core Tools](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=v4%2Clinux%2Ccsharp%2Cportal%2Cbash#install-the-azure-functions-core-tools)

  Azure Functions Core Tools lets you develop and test your functions on your local computer from the command prompt or terminal. Your local functions can connect to live Azure services, and you can debug your functions on your local computer using the full Functions runtime. You can even deploy a function app to your Azure subscription.

---

## CosmosDB

- [Create Free-Tier CosmosDB](https://github.com/drminnaar/azure-iac/tree/main/cosmosdb/cosmosdb-free-tier-create)

  - [Azure CLI](https://github.com/drminnaar/azure-iac/tree/main/cosmosdb/cosmosdb-free-tier-create/cosmosdb-create-azcli)
  - [Azure Powershell](https://github.com/drminnaar/azure-iac/tree/main/cosmosdb/cosmosdb-free-tier-create/cosmosdb-create-azpwsh)
  - [Azure Bicep](https://github.com/drminnaar/azure-iac/tree/main/cosmosdb/cosmosdb-free-tier-create/cosmosdb-create-bicep-part-1)
  - [Azure Bicep using Modules](https://github.com/drminnaar/azure-iac/tree/main/cosmosdb/cosmosdb-free-tier-create/cosmosdb-create-bicep-part-2)

---

## Functions

### Function App - Consumption Plan

- [Create Function App Using Consumption Plan](https://github.com/drminnaar/azure-iac/tree/main/functions/function-app-create-consumption-plan)

  - [Azure CLI](https://github.com/drminnaar/azure-iac/tree/main/functions/function-app-create-consumption-plan/function-app-create-consumption-plan-azcli)
  - [Azure Powershell](https://github.com/drminnaar/azure-iac/tree/main/functions/function-app-create-consumption-plan/function-app-create-consumption-plan-azpwsh)
  - [Azure Bicep](https://github.com/drminnaar/azure-iac/tree/main/functions/function-app-create-consumption-plan/function-app-create-consumption-plan-bicep-part-1)
  - [Azure Bicep using modules](https://github.com/drminnaar/azure-iac/tree/main/functions/function-app-create-consumption-plan/function-app-create-consumption-plan-bicep-part-2)

### Function App - Basic Plan

- [Create Function App Using Basic Plan](https://github.com/drminnaar/azure-iac/tree/main/functions/function-app-create-basic-plan)

  - [Azure CLI](https://github.com/drminnaar/azure-iac/tree/main/functions/function-app-create-basic-plan/function-app-create-basic-plan-azcli)
  - [Azure Powershell](https://github.com/drminnaar/azure-iac/tree/main/functions/function-app-create-basic-plan/function-app-create-basic-plan-azpwsh)
  - [Azure Bicep](https://github.com/drminnaar/azure-iac/tree/main/functions/function-app-create-basic-plan/function-app-create-basic-plan-bicep-part-1)
  - [Azure Bicep using modules](https://github.com/drminnaar/azure-iac/tree/main/functions/function-app-create-basic-plan/function-app-create-basic-plan-bicep-part-2)

---

## Networking

### VNet

- [Create VNet](https://github.com/drminnaar/azure-iac/tree/main/network/vnet/vnet-create)
  - [Azure CLI](https://github.com/drminnaar/azure-iac/tree/main/network/vnet/vnet-create/vnet-create-azcli)
  - [Azure Powershell](https://github.com/drminnaar/azure-iac/tree/main/network/vnet/vnet-create/vnet-create-azpwsh)
  - [Azure Bicep](https://github.com/drminnaar/azure-iac/tree/main/network/vnet/vnet-create/vnet-create-bicep-part-1)
  - [Azure Bicep using Modules](https://github.com/drminnaar/azure-iac/tree/main/network/vnet/vnet-create/vnet-create-bicep-part-2)
- [Create Multi-Tier VNet](https://github.com/drminnaar/azure-iac/tree/main/network/vnet/vnet-create-multitier)
  - [Azure CLI](https://github.com/drminnaar/azure-iac/tree/main/network/vnet/vnet-create-multitier/vnet-create-multitier-using-azcli)
  - [Azure Bicep](https://github.com/drminnaar/azure-iac/tree/main/network/vnet/vnet-create-multitier/vnet-create-multitier-using-bicep)
- [Create Multi-Tier VNet with Virtual Machines](https://github.com/drminnaar/azure-iac/tree/main/network/vnet/vnet-create-multitier-vm)
  - [Azure CLI](https://github.com/drminnaar/azure-iac/tree/main/network/vnet/vnet-create-multitier-vm/vnet-create-multitier-vm-using-azcli)
  - [Azure Bicep](https://github.com/drminnaar/azure-iac/tree/main/network/vnet/vnet-create-multitier-vm/vnet-create-multitier-vm-using-bicep-part-1)
  - [Azure Bicep using modules per tier](https://github.com/drminnaar/azure-iac/tree/main/network/vnet/vnet-create-multitier-vm/vnet-create-multitier-vm-using-bicep-part-2)
  - [Azure Bicep using modules for everything](https://github.com/drminnaar/azure-iac/tree/main/network/vnet/vnet-create-multitier-vm/vnet-create-multitier-vm-using-bicep-part-3)

---

## Storage Accounts

### Create Standard Storage Account

[Create Standard Storage Account](https://github.com/drminnaar/azure-iac/tree/main/storage/storage-account-create)

  - [Azure CLI](https://github.com/drminnaar/azure-iac/tree/main/storage/storage-account-create/storage-account-create-azcli)
  - [Azure Powershell](https://github.com/drminnaar/azure-iac/tree/main/storage/storage-account-create/storage-account-create-azpwsh)
  - [Azure Bicep](https://github.com/drminnaar/azure-iac/tree/main/storage/storage-account-create/storage-account-create-bicep-part-1)
  - [Azure Bicep using modules](https://github.com/drminnaar/azure-iac/tree/main/storage/storage-account-create/storage-account-create-bicep-part-2)

---

## Web

### App Service

- [Create App Service Plan](https://github.com/drminnaar/azure-iac/tree/main/web/app-service/app-service-plan-create)

  - [Azure CLI](https://github.com/drminnaar/azure-iac/tree/main/web/app-service/app-service-plan-create/app-service-plan-create-azcli)
  - [Azure Powershell](https://github.com/drminnaar/azure-iac/tree/main/web/app-service/app-service-plan-create/app-service-plan-create-azpwsh)
  - [Azure Bicep](https://github.com/drminnaar/azure-iac/tree/main/web/app-service/app-service-plan-create/app-service-plan-create-bicep-part-1)
  - [Azure Bicep using Modules](https://github.com/drminnaar/azure-iac/tree/main/web/app-service/app-service-plan-create/app-service-plan-create-bicep-part-2)

  ---
