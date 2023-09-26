terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.64.0"
    }
  }
    backend "azurerm" {
    resource_group_name  = var.RESOURCE_GROUP_NAME_STATE
    storage_account_name = var.STORAGE_ACCOUNT_NAME_STATE
    container_name       = var.CONTAINER_NAME_STATE
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "terraformrg" {
    name = var.RESOURCE_GROUP_NAME
    location = var.LOCATION
}


resource "azurerm_storage_account" "storageaccount" {
  name                     = var.STORAGE_ACCOUNT
  resource_group_name      = azurerm_resource_group.terraformrg.name
  location                 = azurerm_resource_group.terraformrg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "serviceplan" {
    name                = var.SERVICE_PLAN
    location            = azurerm_resource_group.terraformrg.location
    resource_group_name = azurerm_resource_group.terraformrg.name
    os_type             = "Linux"
    sku_name            = "B1"
}

resource "azurerm_linux_function_app" "functionapp" {
  name                = var.FUNCTION_APP
  resource_group_name = azurerm_resource_group.terraformrg.name
  location            = azurerm_resource_group.terraformrg.location

  storage_account_name       = azurerm_storage_account.storageaccount.name
  storage_account_access_key = azurerm_storage_account.storageaccount.primary_access_key
  service_plan_id            = azurerm_service_plan.serviceplan.id

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME       = "dotnet-isolated"
    SCM_DO_BUILD_DURING_DEPLOYMENT = "false"
  }
  site_config {
    application_stack {
      dotnet_version              = "7.0"
      use_dotnet_isolated_runtime = true
    }
  }
}