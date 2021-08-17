// Tags
//**********************************************************************************************
resource_tags = {
  version = "1.0"
}

deployment_tags = {
  environment = "staging"
  region      = "uksouth"
  Compliance = "Not_Applicable"
  DRProtected = "Yes"
  Creator     = "azrizvi@avaya.com"
  CloudOwner = "pachawla@avaya.com"
  ApplicationName = "Workspace"
  BusinessOwner = "pflan@avaya.com"
  ApplicationOwner = "padraiwa@avaya.com"
}
//**********************************************************************************************

Environment = "staging"
// Resource Group
//**********************************************************************************************
resource_group = {
  common = {
    name     = "auks-00e-s-ws-rg02"
    location = "east us"
  }
}
//**********************************************************************************************


// Network Security Group
//**********************************************************************************************


# NSG and rules for AKS Cluster
adf_shir_nsg_name = "auks-00e-s-ws-nsg01"
adf_shir_security_rule = {
  Deny_SSH_RDP = {
    name                                       = "Deny_SSH_RDP"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Deny"
    protocol                                   = "*"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = null
    destination_port_ranges                    = ["3389","22"]
    source_address_prefix                      = "*"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Unblock access to Private IP address"
  },
  VirtualNetwork_Inbound = {
    name                                       = "VirtualNetwork_Inbound"
    priority                                   = 900
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = "*"
    destination_port_ranges                    = null
    source_address_prefix                      = "VirtualNetwork"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Unblock access to Private IP address"
  },
  AzureLoadBalancer_Inbound = {
    name                                       = "AzureLoadBalancer_Inbound"
    priority                                   = 110
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = "*"
    destination_port_ranges                    = null
    source_address_prefix                      = "AzureLoadBalancer"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Unblock access to Azure Load Balancer"
  },
  deny_inbound = {
    name                                       = "denyInbound"
    priority                                   = 1000
    direction                                  = "Inbound"
    access                                     = "Deny"
    protocol                                   = "*"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = "*"
    destination_port_ranges                    = null
    source_address_prefix                      = "*"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Deny All the traffic"
  },
  #OutBound
  deny_outbound = {
    name                                       = "denyoutbound"
    priority                                   = 1000
    direction                                  = "Outbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = "*"
    destination_port_ranges                    = null
    source_address_prefix                      = "*"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Deny All the traffic"
  },
  VirtualNetwork_OutBound = {
    name                                       = "VirtualNetwork_OutBound"
    priority                                   = 100
    direction                                  = "Outbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = "*"
    destination_port_ranges                    = null
    source_address_prefix                      = "*"
    source_address_prefixes                    = null
    destination_address_prefix                 = "VirtualNetwork"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Unblcok access to Private IP address"
  }
}

# NSG and rules for Private EndPoint
pe_nsg_name = "auks-00e-s-ws-nsg02"
pe_security_rule = {
  Deny_SSH_RDP = {
    name                                       = "Deny_SSH_RDP"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Deny"
    protocol                                   = "*"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = null
    destination_port_ranges                    = ["3389","22"]
    source_address_prefix                      = "*"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Unblock access to Private IP address"
  },
  VirtualNetwork_Inbound = {
    name                                       = "VirtualNetwork_Inbound"
    priority                                   = 900
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = "*"
    destination_port_ranges                    = null
    source_address_prefix                      = "VirtualNetwork"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Unblock access to Private IP address"
  },
  deny_inbound = {
    name                                       = "denyInbound"
    priority                                   = 1000
    direction                                  = "Inbound"
    access                                     = "Deny"
    protocol                                   = "*"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = "*"
    destination_port_ranges                    = null
    source_address_prefix                      = "*"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Deny All the traffic"
  },
  #OutBound
  deny_outbound = {
    name                                       = "denyoutbound"
    priority                                   = 1000
    direction                                  = "Outbound"
    access                                     = "Deny"
    protocol                                   = "*"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = "*"
    destination_port_ranges                    = null
    source_address_prefix                      = "*"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Deny All the traffic"
  },
  VirtualNetwork_OutBound = {
    name                                       = "VirtualNetwork_OutBound"
    priority                                   = 100
    direction                                  = "Outbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = "*"
    destination_port_ranges                    = null
    source_address_prefix                      = "*"
    source_address_prefixes                    = null
    destination_address_prefix                 = "VirtualNetwork"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Unblcok access to Private IP address"
  }
}

# NSG rules for Application Gateway
appgateway_nsg_name = "auks-00e-s-ws-nsg05"
appgateway_security_rule = {
  GatewayManager = {
    name                                       = "GatewayManager"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "tcp"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = null
    destination_port_ranges                    = ["65200-65535"]
    source_address_prefix                      = "GatewayManager"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Azure infrastructure communication"
  },
  AzureLoadBalancer = {
    name                                       = "AzureLoadBalancer"
    priority                                   = 110
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "tcp"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = "*"
    destination_port_ranges                    = null
    source_address_prefix                      = "AzureLoadBalancer"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Azure Load Balancer"
  },
  allow_http = {
    name                                       = "AllowHTTP"
    priority                                   = 120
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "tcp"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = null
    destination_port_ranges                    = ["80"]
    source_address_prefix                      = "0.0.0.0/0"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "HTTP access from anywhere"
  },
  VirtualNetwork_Inbound = {
    name                                       = "VirtualNetwork_Inbound"
    priority                                   = 130
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = "*"
    destination_port_ranges                    = null
    source_address_prefix                      = "VirtualNetwork"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Unblock access to Private IP address"
  },
  AllowInternet_InBound = {
    name                                       = "AllowInternet_InBound"
    priority                                   = 140
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = "*"
    destination_port_ranges                    = null
    source_address_prefix                      = "Internet"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Allow Internet raffic"
  }
  #OutBlound
  VirtualNetwork_OutBound = {
    name                                       = "VirtualNetwork_OutBound"
    priority                                   = 100
    direction                                  = "Outbound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = "*"
    destination_port_ranges                    = null
    source_address_prefix                      = "*"
    source_address_prefixes                    = null
    destination_address_prefix                 = "VirtualNetwork"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Unblcok access to Private IP address"
  },
  AllowInternet_OutBound = {
    name                                       = "AllowInternet_OutBound"
    priority                                   = 120
    direction                                  = "OutBound"
    access                                     = "Allow"
    protocol                                   = "*"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = "*"
    destination_port_ranges                    = null
    source_address_prefix                      = "*"
    source_address_prefixes                    = null
    destination_address_prefix                 = "Internet"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Allow Internet raffic"
  }
} 

adf_shir_subnetname ="auks-00e-s-ws-sn01"
pe_subnetname ="auks-00e-s-ws-sn02"
appgateway_subnetname ="auks-00e-s-ws-sn05"
//**********************************************************************************************


// Virtual Network
//**********************************************************************************************

# Spoke Vnet
vnet_spoke = {
  spoke1 = {
    name          = "auks-00e-s-ws-vn01"
    address_space = ["10.150.172.0/22"]
  }
}

ddos_protection_plan ={
/*
  ddos1 = {
    id     = "/subscriptions/2233010f-e7cf-4cf7-80d1-429d098072c2/resourceGroups/aeu2-2c2-nh-ws-rg01/providers/Microsoft.Network/ddosProtectionPlans/aeu2-2c2-nh-ws-dos01"
    enable = true
  }
  */
}

//**********************************************************************************************


// Subnet
//**********************************************************************************************
service_endpoints = []//["Microsoft.Sql", "Microsoft.ContainerRegistry"]


 //Log Analytics
//**********************************************************************************************
log_analytics_workspace_name = "auks-00e-s-ws-la01"
solutions = {
  AzureNSGAnalytics = {
    publisher = "Microsoft"
    product   = "OMSGallery/AzureNSGAnalytics"
  }
}
//**********************************************************************************************

#################keyvault#################################

Keyvault ={
  name = "auks-00e-s-ws-kv-78"
  enabled_for_deployment = true
  enabled_for_disk_encryption   = true
  enabled_for_template_deployment = true
  sku_name  = "premium"
  soft_delete_enabled = true
  soft_delete_retention_days = 90
  purge_protection_enabled = false
}


fileshare = {
  name                        = "auks00eswsfg01"
  account_tier                = "premium"
  account_replication_type    = "LRS"
  account_kind                = "FileStorage"
  delete_retention_policy     = 90
}
############# Applivation gateway Name ############
appgatewayname = "auks-00e-s-ws-aag01"
appgateway_publicIP_domain_name_label ="avayastguksaag01"
############## ACR Name ####################
acr_name = "auks00eswsacr49"
###############Subnets########################
adf_shir_subnet_cidr = ["10.150.172.0/26"]
pe_subnet_cidr = ["10.150.172.64/27"]
fw_subnet_cidr = ["10.150.172.192/26"]
application_gateway_subnet_cidr = ["10.150.173.0/24"]


standalone_route_private = {
/*
  standalone = {
    name                   = "standalone"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "None"
    next_hop_in_ip_address = null
  }*/
}

//**********************************************************************************************
// Route Table
//**********************************************************************************************
route_table = {
/*
  aks = {
    name                          = "auks-00e-s-ws-rt01"
    disable_bgp_route_propagation = false
  },*/
  private = {
    name                          = "auks-00e-s-ws-rt02"
    disable_bgp_route_propagation = false
  }
}


########### Firewall Name ###############
firewall_name ="auks-00e-s-ws-fw01"
firewall_publicIP_domain_name_label ="avayastguksfw01"

additional_firewall_public_ips ={
  /*
    additional_firewall_public_ips1={
        name = "auks-fc5-t-ws-fw01-pip02"
        domain_name_label = "avayastgeu2fw02"
    },
    additional_firewall_public_ips2={
        name = "auks-fc5-t-ws-fw01-pip03"
    },
    */
}

##################Traffic Manager Profile ##########
traffic_manager_profile_name ="auks-00e-s-ws-tmp08"
traffic_routing_method  = "Performance"
traffic_manager_dnsname = "wescotest"


azurerm_user_assigned_identity = "auks-00e-s-ws-uai01"


hubnetwork_devops_subnetID = "/subscriptions/473c3c84-a93a-48ff-b941-a43159f5f9b7/resourceGroups/rsg_09/providers/Microsoft.Network/virtualNetworks/sfdgewrtu/subnets/default"


###################

dns_records = {

}

dns_zone_name = "zonedjdhlkjsl.com"

azurerm_cognitive_accounts = {
    azurerm_cognitive_accounts1={
        name     ="cogsearch100"
        sku_name = "S0"
        kind     = "SpeechServices"
    },
}

app_service_environment = {
    name = "appase01"
    pricing_tier = "I2"
    front_end_scale_factor = 10
    internal_load_balancing_mode = "Web, Publishing"
    allowed_user_ip_cidrs = ["10.0.0.0/23","173.0.0.2/28"]
}

app_service_plan ={
    name = "appserucellibav"
    kind = "app"
    reserved = "false"
    sku_tier = "Premium"
    sku_size = "P1"
    sku_capacity = "1"
}

app_service ={
    name = "appserucellibav"
    sku_tier = "Dynamic"
    sku_size = "Y1"
    https_only = true
    app_settings ={
        "SOME_KEY" = "some-value"
        "name"     = "Ali"
    }
    site_config ={
        "dotnet_framework_version" = "v4.0"
        "scm_tye" = "LocalGit"
    }
}