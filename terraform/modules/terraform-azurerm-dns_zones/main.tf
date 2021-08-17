resource "azurerm_dns_zone" "dns" {
    name                = var.dns_zone_name
    resource_group_name = var.resource_group_name
    
    tags       = merge(var.resource_tags, var.deployment_tags)
}

resource "azurerm_dns_a_record" "dnsrecord" {
    for_each = var.dns_records
    name                = each.value.name
    zone_name           = azurerm_dns_zone.dns.name
    resource_group_name = var.resource_group_name
    ttl                 = each.value.ttl
    records             = each.value.records
}