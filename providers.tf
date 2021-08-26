terraform {
  required_providers {
    azurerm = ">= 2.28"
  }

  backend "azurerm" {
    storage_account_name = "xortfstate01"
    container_name       = "terraformstate"
    key                  = "dev.tfstate"
    access_key           = "LPs2BPXpBxTekaOU/yQwGEMIlBjJA4vYIxekA2iJFLdTmmaHCxWVzKgsgb3uEeTXh/tmTiu9KQueZmzygvpx3Q=="
  }
}

provider "azurerm" {
  features {}
  subscription_id            = var.subscription_id
  client_id                  = var.client_id
  client_secret              = var.client_secret
  tenant_id                  = var.tenant_id
  skip_provider_registration = "true"
}
