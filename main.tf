module "fileshare" {
  source                   = "../TerraformCore/modules/terraform-azurerm-storageaccount"
  resource_group_name      = var.fileshare.resource_grp_name //module.resource_group.resource_group.common.name
  location                 = var.fileshare.location          //module.resource_group.resource_group.common.location
  name                     = var.fileshare.name
  account_tier             = var.fileshare.account_tier
  account_replication_type = var.fileshare.account_replication_type
  account_kind             = var.fileshare.account_kind
  resource_tags            = var.resource_tags
  deployment_tags          = var.deployment_tags
}
/*
module "keyvault" {
  source = "../TerraformCore/modules/terraform-azurerm-keyvault"

  resource_group_name             = var.Keyvault.resource_grp_name //module.resource_group.resource_group.common.name
  location                        = var.Keyvault.location          //module.resource_group.resource_group.common.location
  name                            = var.Keyvault.name
  enabled_for_deployment          = var.Keyvault.enabled_for_deployment
  enabled_for_disk_encryption     = var.Keyvault.enabled_for_disk_encryption
  enabled_for_template_deployment = var.Keyvault.enabled_for_template_deployment
  tenant_id                       = "7c10e4ef-1eb3-403a-9af7-c0aae38648ef" //data.azurerm_client_config.current.tenant_id
  sku_name                        = var.Keyvault.sku_name
  soft_delete_enabled             = var.Keyvault.soft_delete_enabled
  soft_delete_retention_days      = var.Keyvault.soft_delete_retention_days
  purge_protection_enabled        = var.Keyvault.purge_protection_enabled

  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}
*/
/*

module "resource_group" {
  source         = "../TerraformCore/TerraformCore/modules/terraform-azurerm-resource-group"
  resource_group = var.resource_group

  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}


module "pe_nsg" {
  source     = "../TerraformCore/TerraformCore/modules/terraform-azurerm-network-security-group"
  depends_on = [module.resource_group]
  name   =  var.pe_nsg_name

  resource_group_name = module.resource_group.resource_group.common.name
  location            = module.resource_group.resource_group.common.location

  security_rule = var.pe_security_rule

  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}

module "adf_shir_nsg" {
  source     = "../TerraformCore/modules/terraform-azurerm-network-security-group"
  depends_on = [module.resource_group]
  name   = var.adf_shir_nsg_name

  resource_group_name = module.resource_group.resource_group.common.name
  location            = module.resource_group.resource_group.common.location

  security_rule = var.adf_shir_security_rule

  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}
module "aks_nsg" {
  source     = "../TerraformCore/modules/terraform-azurerm-network-security-group"
  depends_on = [module.resource_group]
  name   = var.aks_nsg_name

  resource_group_name = module.resource_group.resource_group.common.name
  location            = module.resource_group.resource_group.common.location

  security_rule = var.aks_security_rule

  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}

module "vnet_spoke" {
  source     = "../TerraformCore/modules/terraform-azurerm-virtual-network"
  depends_on = [module.resource_group]

  resource_group_name = module.resource_group.resource_group.common.name
  location            = module.resource_group.resource_group.common.location
  ddos_protection_plan  = var.ddos_protection_plan
  vnet = var.vnet_spoke

  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}

// Subnet
module "subnet_spoke" {
  source     = "../TerraformCore/modules/terraform-azurerm-subnet"
  depends_on = [module.resource_group, module.vnet_spoke,module.pe_nsg,module.adf_shir_nsg,] #module.route_table]

  resource_group_name = module.resource_group.resource_group.common.name

  subnet_route_table_association                 = true
  network_security_group_association             = true
  enforce_private_link_endpoint_network_policies = true # Required to deploy private endpoint

  subnet = {
    aks_spoke2 = {
      name                      = var.pe_subnetname
      virtual_network_name      = module.vnet_spoke.vnet.spoke1.name
      address_prefixes          = var.pe_subnet_cidr
      network_security_group_id = module.pe_nsg.nsg.id
      route_table_id            = module.route_table["private"].route_table.id
    },
    aks_spoke3 = {
      name                      = var.adf_shir_subnetname
      virtual_network_name      = module.vnet_spoke.vnet.spoke1.name
      address_prefixes          = var.adf_shir_subnet_cidr
      network_security_group_id = module.adf_shir_nsg.nsg.id
      route_table_id            = module.route_table["private"].route_table.id
    },
    aks_spoke1 = {
      name                      = var.aks_subnetname
      virtual_network_name      = module.vnet_spoke.vnet.spoke1.name
      address_prefixes          = var.aks_subnet_cidr
      network_security_group_id = module.aks_nsg.nsg.id
      route_table_id            = module.route_table["private"].route_table.id
    },
  }

  service_endpoints = var.service_endpoints
}


// Log Analytics
module "log_analytics" {
  source              = "../TerraformCore/modules/terraform-azurerm-log-analytics"
  resource_group_name = module.resource_group.resource_group.common.name
  location            = module.resource_group.resource_group.common.location
  name                = var.log_analytics_workspace_name
  solutions           = var.solutions
}

// Route Table and Routes
module "route_table" {
  source     = "../TerraformCore/modules/terraform-azurerm-route-table"
  depends_on = [module.resource_group]
  for_each   = var.route_table

  resource_group_name = module.resource_group.resource_group.common.name
  location            = module.resource_group.resource_group.common.location

  name                          = each.value.name
  disable_bgp_route_propagation = each.value.disable_bgp_route_propagation
  inline_route                  = var.inline_route
  standalone_route              = each.key == "private" ? var.standalone_route_private : var.standalone_route_public

  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}

resource "azurerm_route" "route"{
  resource_group_name    = module.resource_group.resource_group.common.name
  route_table_name       = var.route_table["private"].name
  name                   = "Firewall"
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.firewall.Private_IP
  depends_on = [ module.route_table ]
}

resource "azurerm_role_assignment" "rt" {
  scope                = module.route_table["private"].route_table.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id

  depends_on = [  module.route_table]
}
// Application Gateway

module "application_gateway" {
  source = "../TerraformCore/modules/terraform-azurerm-application-gateway"

  resource_group_name = module.resource_group.resource_group.common.name
  location            = module.resource_group.resource_group.common.location

  appgateway_name  = var.appgatewayname
  subnet_name      = var.appgateway_subnetname
  nsg_name         = var.appgateway_nsg_name
  zones = []
  security_rules   = var.appgateway_security_rule
  # Subnet
  virtual_network_name = module.vnet_spoke.vnet.spoke1.name
  address_prefixes     = var.application_gateway_subnet_cidr
  domain_name_label    = var.appgateway_publicIP_domain_name_label
  autoscale_configurations = {
    min_capacity = 0
    max_capacity = 2
  }

  redirect_configurations = {}

  azurerm_user_assigned_identity = azurerm_user_assigned_identity.userassigned.id
  
  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}

/*
// Azure Container Registry

module "acr" {
  source     = "../TerraformCore/modules/terraform-azurerm-acr"
  depends_on = [module.resource_group, module.subnet_spoke]

  resource_group_name = module.resource_group.resource_group.common.name
  location            = module.resource_group.resource_group.common.location

  name                     = var.acr_name
  sku                      = "Premium"

  #Network/Firewall Rules
  virtual_network = {
    vnet1 = {
      action    = "Allow"
      subnet_id = var.hubnetwork_devops_subnetID
    }
  }

  ip_rule = {
  

  }

  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}


module "spoke_baseline_private_endpoint_acr" {
  source = "../TerraformCore/modules/terraform-azurerm-private-endpoint"

  resource_group_name = module.resource_group.resource_group.common.name
  location            = module.resource_group.resource_group.common.location

  # DNS Zone
  create_dns_zone         = true
  dns_zone_name           = "privatelink.azurecr.io"
  dns_zone_resource_group = module.resource_group.resource_group.common.name
  virtual_network_id      = module.vnet_spoke.vnet.spoke1.id

  name                           = module.acr.acr.name
  private_connection_resource_id = module.acr.acr.id
  subnet_id                      = module.subnet_spoke.subnet.aks_spoke2.id
  subresource_names              = ["registry"]

  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}




module "private_endpoint_fileshare" {
  source = "../TerraformCore/modules/terraform-azurerm-private-endpoint"

  resource_group_name = module.resource_group.resource_group.common.name
  location            = module.resource_group.resource_group.common.location

  # DNS Zone
  create_dns_zone         = true
  dns_zone_name           = "privatelink.blob.core.windows.net"
  dns_zone_resource_group = module.resource_group.resource_group.common.name
  virtual_network_id      = module.vnet_spoke.vnet.spoke1.id

  name                           = module.fileshare.name
  private_connection_resource_id = module.fileshare.id
  subnet_id                      = module.subnet_spoke.subnet.aks_spoke2.id
  subresource_names              = ["file"]

  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}

module "spoke_baseline_private_endpoint_keyvault" {
  source = "../TerraformCore/modules/terraform-azurerm-private-endpoint"

  resource_group_name = module.resource_group.resource_group.common.name
  location            = module.resource_group.resource_group.common.location

  # DNS Zone
  create_dns_zone         = true
  dns_zone_name           = "privatelink.vaultcore.azure.net"
  dns_zone_resource_group = module.resource_group.resource_group.common.name
  virtual_network_id      = module.vnet_spoke.vnet.spoke1.id

  name                           = module.keyvault.name
  private_connection_resource_id = module.keyvault.id
  subnet_id                      = module.subnet_spoke.subnet.aks_spoke2.id
  subresource_names              = ["vault"]

  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}


module "firewall" {
  source = "../TerraformCore/modules/terraform-azurerm-firewall"
  
  resource_group_name = module.resource_group.resource_group.common.name
  location            = module.resource_group.resource_group.common.location

  name                = var.firewall_name
  vnet_name           = module.vnet_spoke.vnet.spoke1.name
  subnet_cidr         = var.fw_subnet_cidr
  domain_name_label   = var.firewall_publicIP_domain_name_label
  resource_tags       = var.resource_tags
  deployment_tags     = var.deployment_tags
  additional_pips     = azurerm_public_ip.fwadditional
}

resource "azurerm_public_ip" "fwadditional" {
  for_each            = var.additional_firewall_public_ips
  name                = each.value["name"]
  resource_group_name = module.resource_group.resource_group.common.name
  location            = module.resource_group.resource_group.common.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

module "traffic_manager" {
  source = "../TerraformCore/modules/terraform-azurerm-traffic-manager"
  
  resource_group_name = module.resource_group.resource_group.common.name

  name                = var.traffic_manager_profile_name
  traffic_routing_method = var.traffic_routing_method
  dnsname =        var.traffic_manager_dnsname

  resource_tags       = var.resource_tags
  deployment_tags     = var.deployment_tags
}

resource "azurerm_user_assigned_identity" "userassigned" {
  resource_group_name = module.resource_group.resource_group.common.name
  location            = module.resource_group.resource_group.common.location

  name = var.azurerm_user_assigned_identity
  
  tags       = merge(var.resource_tags, var.deployment_tags)
}

resource "azurerm_user_assigned_identity" "aks" {
  resource_group_name = module.resource_group.resource_group.common.name
  location            = module.resource_group.resource_group.common.location

  name = var.aks_user_assigned_identity
  
  tags       = merge(var.resource_tags, var.deployment_tags)
}

resource "azurerm_key_vault_access_policy" "identity" {
  key_vault_id = module.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.userassigned.principal_id

  key_permissions = [
    "Get","List"
  ]

  secret_permissions = [
    "Get","List"
  ]

  certificate_permissions = [
    "Get","List"
  ]
}

resource "azurerm_key_vault_key" "fileshare" {
  name         = "fileshare"
  key_vault_id = module.keyvault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  depends_on = [azurerm_key_vault_access_policy.identity]
}

resource "azurerm_key_vault_access_policy" "spn" {
  key_vault_id = module.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get","List"
  ]

  secret_permissions = [
    "Get","List"
  ]

  certificate_permissions = [
    "Get","List"
  ]
}

module "dns_zones" {
    source = "../TerraformCore/modules/terraform-azurerm-dns_zones"
    dns_zone_name = var.dns_zone_name
    resource_group_name = module.resource_group.resource_group.common.name
    dns_records = var.dns_records
    resource_tags   = var.resource_tags
    deployment_tags = var.deployment_tags
}

module "cognitive_account" {
    source = "../TerraformCore/modules/terraform-azurerm-cognitive_account"
    azurerm_cognitive_accounts = var.azurerm_cognitive_accounts
    resource_group_name = module.resource_group.resource_group.common.name
    location =  module.resource_group.resource_group.common.location
    resource_tags   = var.resource_tags
    deployment_tags = var.deployment_tags
}   

module "web_app" {
    source = "../TerraformCore/modules/terraform-azurerm-webapp"
    app_service_environment = var.app_service_environment
    app_service = var.app_service
    app_service_plan = var.app_service_plan
    //subnet_name = "default"
    //virtual_network_name = module.vnet_spoke.vnet.spoke1.name
    resource_group_name = module.resource_group.resource_group.common.name
    location = module.resource_group.resource_group.common.location
    resource_tags   = var.resource_tags
    deployment_tags = var.deployment_tags
}
module "aks" {
  source     = "../TerraformCore/modules/terraform-azurerm-aks"

  resource_group_name = module.resource_group.resource_group.common.name
  location            = module.resource_group.resource_group.common.location

  name               = var.aks_name
  kubernetes_version = var.kubernetes_version
  dns_prefix         = var.aks_dns_prefix

  application_node_pool         = var.application_node_pool
  application_node_pool_scaling = var.application_node_pool_scaling
  application_node_pool_subnet_id  = module.subnet_spoke.subnet.aks_spoke1.id

  network_profile = var.network_profile
  

  system_node_pool         = var.system_node_pool
  system_node_pool_scaling = var.system_node_pool_scaling
  system_node_pool_subnet_id  = module.subnet_spoke.subnet.aks_spoke1.id


  management_node_pool         = var.management_node_pool
  management_node_pool_scaling = var.management_node_pool_scaling
  management_node_pool_subnet_id  = module.subnet_spoke.subnet.aks_spoke1.id

  private_cluster_enabled = false
  # Authentication and Authorization
  #service_principal      = var.service_principal
  user_assigned_identity_id = azurerm_user_assigned_identity.aks.id
  rbac_enabled           = var.rbac_enabled
  azure_active_directory = var.azure_active_directory
  linux_profile          = var.linux_profile

  # Add-on Profiles
  addon_profile_oms_agent = {
    enabled                    = false
    log_analytics_workspace_id = data.azurerm_log_analytics_workspace.workspace.id
  }
  
  addon_profile_http_application_routing = var.addon_profile_http_application_routing

  resource_tags   = var.kubernetes_tags
  deployment_tags = var.deployment_tags

  depends_on = [
    azurerm_role_assignment.rt
  ]

}*/