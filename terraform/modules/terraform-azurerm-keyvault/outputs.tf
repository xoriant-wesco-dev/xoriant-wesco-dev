// Log Analytics Workspace
output "id" {
  value = azurerm_key_vault.keyvault.id
}
output "name" {
  value = azurerm_key_vault.keyvault.name
}