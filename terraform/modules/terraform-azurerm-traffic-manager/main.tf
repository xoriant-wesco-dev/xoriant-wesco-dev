resource "azurerm_traffic_manager_profile" "example" {
  name                = var.name
  resource_group_name = var.resource_group_name

  traffic_routing_method = var.traffic_routing_method

  dns_config {
    relative_name = var.dnsname
    ttl           = 100
  }
  
  monitor_config {
    protocol                     = "http"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }

    tags                        = merge(var.resource_tags, var.deployment_tags)
}
/*
resource "azurerm_traffic_manager_endpoint" "tm-endpoint-west" {
  name                = "Gateway West"
  resource_group_name = "${azurerm_resource_group.resource-group-global.name}"
  profile_name        = "${azurerm_traffic_manager_profile.traffic-manager.name}"
  type                = "externalEndpoints"
  target              = "${azurerm_public_ip.pip_west.fqdn}"
  endpoint_location   = "${azurerm_public_ip.pip_west.location}"
}
*/