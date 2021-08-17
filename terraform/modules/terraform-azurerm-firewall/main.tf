resource "azurerm_public_ip" "pip" {
  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  domain_name_label   = var.domain_name_label

  tags       = merge(var.resource_tags, var.deployment_tags)

}

resource "azurerm_firewall" "fw" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.sn.id
    public_ip_address_id = azurerm_public_ip.pip.id
  }
    
  dynamic ip_configuration {
    for_each = var.additional_pips
    content{
      name                 = ip_configuration.value.name
      public_ip_address_id = ip_configuration.value.id
    }
  }

  tags       = merge(var.resource_tags, var.deployment_tags)
}


resource "azurerm_subnet" "sn" {
  name                 = "AzureFirewallSubnet"
  virtual_network_name = var.vnet_name
  resource_group_name = var.resource_group_name
  address_prefixes     = var.subnet_cidr
}

resource "azurerm_firewall_network_rule_collection" "rule" {
  name                = "Allow_Internet"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_firewall.fw.resource_group_name
  priority            = 1000
  action              = "Allow"

  rule {
    name = "Allow_Internet"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "*",
    ]

    destination_addresses = [
      "*"
    ]

    protocols = [
      "TCP","UDP"
    ]
  }
}