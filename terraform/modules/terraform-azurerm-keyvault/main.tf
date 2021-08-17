resource "azurerm_key_vault" "keyvault" {
  name                              = var.name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  enabled_for_deployment            = var.enabled_for_deployment
  enabled_for_disk_encryption       = var.enabled_for_disk_encryption
  enabled_for_template_deployment   = var.enabled_for_template_deployment
  tenant_id                         = var.tenant_id
  sku_name                          = var.sku_name

  soft_delete_retention_days  = var.soft_delete_retention_days
  purge_protection_enabled    = var.purge_protection_enabled

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags       = merge(var.resource_tags, var.deployment_tags)
}