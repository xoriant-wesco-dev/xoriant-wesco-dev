resource "azurerm_cognitive_account" "example" {
    for_each = var.azurerm_cognitive_accounts
    name                = each.value.name
    location            = var.location
    resource_group_name = var.resource_group_name
    kind                = each.value.kind

    sku_name            = each.value.sku_name

    tags       = merge(var.resource_tags, var.deployment_tags)
}