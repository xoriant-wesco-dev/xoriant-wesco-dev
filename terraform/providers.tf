terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = ">= 2.28"
  }
/*
  backend "azurerm" {
    resource_group_name  = "avayastoragelabbackend"
    storage_account_name = "avayastoragelabbackend"
    container_name       = "tfstate"
    key                  = "lab-eastus2/common/terraform.tfstate"
    access_key 		       = "StorageAccountKey"
  }
  */
}

provider "azurerm" {
  features {}
  /*
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  */
}
