output "Private_IP" {
  value = azurerm_firewall.fw.ip_configuration[0].private_ip_address
}
