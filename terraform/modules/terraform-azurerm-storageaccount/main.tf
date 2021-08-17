resource "azurerm_storage_account" "storage" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  account_tier                = var.account_tier
  account_replication_type    = var.account_replication_type
  account_kind                = var.account_kind


identity {
  type = "SystemAssigned"
}

  tags  = merge(var.resource_tags, var.deployment_tags)
}


resource "azurerm_storage_account_network_rules" "storage" {
  resource_group_name  = azurerm_storage_account.storage.resource_group_name
  storage_account_name = azurerm_storage_account.storage.name
  bypass                     = []
  default_action             = "Deny"
}

/*
resource "azurerm_storage_account_customer_managed_key" "storage" {
  storage_account_id = azurerm_storage_account.storage.id
  key_vault_id       = var.keyvault_id
  key_name           = var.key_name
}
*/