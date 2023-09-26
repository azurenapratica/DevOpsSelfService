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

resource "azurerm_service_plan" "serviceplan" {
    name                = var.SERVICE_PLAN
    location            = azurerm_resource_group.terraformrg.location
    resource_group_name = azurerm_resource_group.terraformrg.name
    os_type             = "Windows"
    sku_name            = "B1"
}

resource "azurerm_windows_web_app" "appService" {
    name                = var.APP_SERVICE
    location            = azurerm_resource_group.terraformrg.location
    resource_group_name = azurerm_resource_group.terraformrg.name
    service_plan_id     = azurerm_service_plan.serviceplan.id
    site_config          {
        application_stack  {
          current_stack  = "dotnetcore"
          dotnet_version = "v7.0"
      }
    }
}