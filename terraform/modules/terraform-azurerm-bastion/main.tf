resource "azurerm_public_ip" "pip" {
  name                = "${var.bastion_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags       = merge(var.resource_tags, var.deployment_tags)
}

resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet.id
    public_ip_address_id = azurerm_public_ip.pip.id
  }
  tags       = merge(var.resource_tags, var.deployment_tags)
}

resource "azurerm_subnet" "subnet" {
  resource_group_name           = var.resource_group_name
  name                          = "AzureBastionSubnet"
  virtual_network_name          = var.virtual_network_name
  address_prefixes              = var.address_prefixes
}