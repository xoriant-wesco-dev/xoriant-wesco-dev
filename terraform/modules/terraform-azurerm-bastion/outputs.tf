// Virtual Network
output "bastionid" {
  description = "Resource ID of azure bastion service"
  value       = azurerm_bastion_host.bastion.id
}