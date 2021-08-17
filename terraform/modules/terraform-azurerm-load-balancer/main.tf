resource "azurerm_public_ip" "pip" {
  name                = "${var.name}-pip1"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["3"]
}

resource "azurerm_lb" "lb" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip.id
    //subnet_id           = var.subnet_id
    //private_ip_address_allocation = "Static"
  }
  tags       = merge(var.resource_tags, var.deployment_tags)
}