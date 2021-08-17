// Virtual Network
output "privateip" {
  description = "vm private ip"
  value       = azurerm_linux_virtual_machine.myterraformvm.private_ip_address
}