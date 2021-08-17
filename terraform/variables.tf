// Providers
/*
variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "Environment" {}

*/
// Tags
//**********************************************************************************************
variable "resource_tags" {
  type        = map(string)
  description = "(Optional) Tags for resources"
  default     = {}
}

variable "deployment_tags" {
  type        = map(string)
  description = "(Optional) Tags for deployment"
  default     = {}
}
//**********************************************************************************************


// Resource Group
//**********************************************************************************************
variable "resource_group" {
  type = map(object({
    name     = string
    location = string
  }))
  description = "(Required) Resource Group Name and Location"
  default     = {}
}
//**********************************************************************************************


// Network Security Group
//**********************************************************************************************
variable "pe_nsg_name" {
  type = string
  description = "(Required) List of NSGs to be created"
  default = ""
}
variable "adf_shir_nsg_name" {
  type = string
  description = "(Required) List of NSGs to be created"
  default = ""
}
variable "appgateway_nsg_name" {
  type        = string
  description = "(Required) NSG for app gateway to be created"
}


#######security rule ###########

variable "adf_shir_security_rule" {
  type = map(object({
    name                                       = string       #(Required) The name of the security rule
    priority                                   = number       #(Required) Specifies the priority of the rule. The value can be between 100 and 4096
    direction                                  = string       #(Required) The direction specifies if rule will be evaluated on incoming or outgoing traffic
    access                                     = string       #(Required) Specifies whether network traffic is allowed or denied
    protocol                                   = string       #(Required) Network protocol this rule applies to. Can be Tcp, Udp, Icmp, or * to match all
    source_port_range                          = string       #(Optional) Source Port or Range. Integer or range between 0 and 65535 or * to match any
    source_port_ranges                         = list(string) #(Optional) List of source ports or port ranges
    destination_port_range                     = string       #(Optional) Destination Port or Range. Integer or range between 0 and 65535 or * to match any
    destination_port_ranges                    = list(string) #(Optional) List of destination ports or port ranges
    source_address_prefix                      = string       #(Optional) CIDR or source IP range or * to match any IP
    source_address_prefixes                    = list(string) #(Optional) List of source address prefixes. Tags may not be used
    destination_address_prefix                 = string       #(Optional) CIDR or destination IP range or * to match any IP
    destination_address_prefixes               = list(string) #(Optional) List of destination address prefixes
    source_application_security_group_ids      = list(string) #(Optional) A List of source Application Security Group ID's
    destination_application_security_group_ids = list(string) #(Optional) A List of destination Application Security Group ID's
    description                                = string       #(Optional) A description for this rule. Restricted to 140 characters
  }))
  description = "(Optional) List of objects representing security rules"
  default     = {}
}

variable "pe_security_rule" {
  type = map(object({
    name                                       = string       #(Required) The name of the security rule
    priority                                   = number       #(Required) Specifies the priority of the rule. The value can be between 100 and 4096
    direction                                  = string       #(Required) The direction specifies if rule will be evaluated on incoming or outgoing traffic
    access                                     = string       #(Required) Specifies whether network traffic is allowed or denied
    protocol                                   = string       #(Required) Network protocol this rule applies to. Can be Tcp, Udp, Icmp, or * to match all
    source_port_range                          = string       #(Optional) Source Port or Range. Integer or range between 0 and 65535 or * to match any
    source_port_ranges                         = list(string) #(Optional) List of source ports or port ranges
    destination_port_range                     = string       #(Optional) Destination Port or Range. Integer or range between 0 and 65535 or * to match any
    destination_port_ranges                    = list(string) #(Optional) List of destination ports or port ranges
    source_address_prefix                      = string       #(Optional) CIDR or source IP range or * to match any IP
    source_address_prefixes                    = list(string) #(Optional) List of source address prefixes. Tags may not be used
    destination_address_prefix                 = string       #(Optional) CIDR or destination IP range or * to match any IP
    destination_address_prefixes               = list(string) #(Optional) List of destination address prefixes
    source_application_security_group_ids      = list(string) #(Optional) A List of source Application Security Group ID's
    destination_application_security_group_ids = list(string) #(Optional) A List of destination Application Security Group ID's
    description                                = string       #(Optional) A description for this rule. Restricted to 140 characters
  }))
  description = "(Optional) List of objects representing security rules"
  default     = {}
}

variable "appgateway_security_rule" {
  type = map(object({
    name                                       = string       #(Required) The name of the security rule
    priority                                   = number       #(Required) Specifies the priority of the rule. The value can be between 100 and 4096
    direction                                  = string       #(Required) The direction specifies if rule will be evaluated on incoming or outgoing traffic
    access                                     = string       #(Required) Specifies whether network traffic is allowed or denied
    protocol                                   = string       #(Required) Network protocol this rule applies to. Can be Tcp, Udp, Icmp, or * to match all
    source_port_range                          = string       #(Optional) Source Port or Range. Integer or range between 0 and 65535 or * to match any
    source_port_ranges                         = list(string) #(Optional) List of source ports or port ranges
    destination_port_range                     = string       #(Optional) Destination Port or Range. Integer or range between 0 and 65535 or * to match any
    destination_port_ranges                    = list(string) #(Optional) List of destination ports or port ranges
    source_address_prefix                      = string       #(Optional) CIDR or source IP range or * to match any IP
    source_address_prefixes                    = list(string) #(Optional) List of source address prefixes. Tags may not be used
    destination_address_prefix                 = string       #(Optional) CIDR or destination IP range or * to match any IP
    destination_address_prefixes               = list(string) #(Optional) List of destination address prefixes
    source_application_security_group_ids      = list(string) #(Optional) A List of source Application Security Group ID's
    destination_application_security_group_ids = list(string) #(Optional) A List of destination Application Security Group ID's
    description                                = string       #(Optional) A description for this rule. Restricted to 140 characters
  }))
  description = "(Optional) List of objects representing security rules"
  default     = {}
}
//**********************************************************************************************

//Route Table
//**********************************************************************************************
variable "route_table" {
  type = map(object({
    name                          = string #(Required) The name of the route table
    disable_bgp_route_propagation = bool   #(Optional) Boolean flag which controls propagation of routes learned by BGP on that route table
  }))
  description = "(Required) private route arguments"
  default     = {}
}

# Optional Variables
variable "inline_route" {
  type = list(object({
    name                   = string #(Required) The name of the route
    address_prefix         = string #(Required) The destination CIDR to which the route applies
    next_hop_type          = string #(Required) The type of Azure hop the packet should be sent to
    next_hop_in_ip_address = string #(Optional) Contains the IP address packets should be forwarded to
  }))
  description = "(Optional) List of objects representing Inline routes"
  default     = []
}

variable "standalone_route_public" {
  type = map(object({
    name                   = string #(Required) The name of the route
    address_prefix         = string #(Required) The destination CIDR to which the route applies
    next_hop_type          = string #(Required) The type of Azure hop the packet should be sent to
    next_hop_in_ip_address = string #(Optional) Contains the IP address packets should be forwarded 
  }))
  description = "(Optional) Standalone routes"
  default     = {}
}

variable "standalone_route_private" {
  type = map(object({
    name                   = string #(Required) The name of the route
    address_prefix         = string #(Required) The destination CIDR to which the route applies
    next_hop_type          = string #(Required) The type of Azure hop the packet should be sent to
    next_hop_in_ip_address = string #(Optional) Contains the IP address packets should be forwarded 
  }))
  description = "(Optional) Standalone routes"
  default     = {}
}

// Virtual Network
//**********************************************************************************************
variable "vnet_hub" {
  type = map(object({
    name          = string
    address_space = list(string)
  }))
  description = "(Required) Vnet name and CIDR block details"
  default     = {}
}
variable "vnet_spoke" {
  type = map(object({
    name          = string
    address_space = list(string)
  }))
  description = "(Required) Vnet name and CIDR block details"
  default     = {}
}
variable "ddos_protection_plan" {
  type = map(object({
    id     = string #(Required) The Resource ID of DDoS Protection Plan
    enable = bool   #(Required) Enable/disable DDoS Protection Plan on Virtual Network
  }))
  description = "(Optional) A ddos_protection_plan block"
  default     = {}
}
variable "dns_servers" {
  type        = list(string)
  description = "(Optional) List of IP addresses of DNS servers"
  default     = []
}


// Subnet

//**********************************************************************************************
variable "service_endpoints" {
  type        = list(string)
  description = "(Optional) The list of Service endpoints to associate with the subnet"
  default     = []
}
//**********************************************************************************************



// Log Analytics
//**********************************************************************************************
variable "log_analytics_workspace_name" {
  type        = string
  description = "(Required) Specifies the name of the Log Analytics Workspace. Workspace name should include 4-63 letters, digits or '-'"
  default     = "log-workspace-test"
}

variable "solutions" {
  type = map(object({
    publisher = string #(Required) The publisher of the solution
    product   = string #(Required) The product name of the solution
  }))
  description = "(Optional) A plan block"
  default     = {}
}


//**********************************************************************************************
######################## KeyVault#####################

variable "Keyvault" {
   type = any
   description = "Azure Key Vaults details"
}

variable "fileshare" {
    type = any
}
########################## App Gateway name ################

variable "appgatewayname"{
    type = string
    description = "(Required) Nmae for Application gateway"
}

variable "appgateway_publicIP_domain_name_label" {
  type        = string
  description = "(Optional) Label for the Domain Name. Will be used to make up the FQDN"
  default     = null
}
########################## Azure container registry name ################

variable "acr_name"{
    type = string
    description =  "Azure container registry Name"
}


###########################Subnet Name #########################
variable "appgateway_subnetname"{
    type = string
    description =  "appgateway subnet name"
}
variable "pe_subnetname"{
    type = string
    description =  "private endpoints subnet"
}
variable "adf_shir_subnetname"{
    type = string
    description =  "adf shir name"
}


############################Subnet address#######################

variable "adf_shir_subnet_cidr"{
    type = list
    description =  "address space azure klubernets subnet"
}
variable "pe_subnet_cidr"{
    type = list
    description =  "address space private endpoints subnet"
}
variable "application_gateway_subnet_cidr"{
    type = list
    description =  "address space application gateway subnet or public"
}

variable "fw_subnet_cidr"{
    type = list
    description = "address space for Firewall"
}

######################## Firewall ###################

variable "firewall_name" {
    type = string
    description =  "Azure firewall name"
}

variable "firewall_publicIP_domain_name_label" {
  type        = string
  description = "(Optional) Label for the Domain Name. Will be used to make up the FQDN"
  default     = null
}

variable "additional_firewall_public_ips" {
    type = map(object({
        name = string
        domain_name_label = string
    }))
    description = "(optional) describe your variable"
}

######################## Traffic Mnager Profile ###################

variable "traffic_manager_profile_name" {
    type = string
    description =  "(Required) Traffic Manager Profile name"
}
variable "traffic_routing_method" {
    type = string
    description =  "(Required) Traffic route method in Traffic Manager"
}
variable "traffic_manager_dnsname" {
    type = string
    description =  "(Required) Traffic Manager DNS Name"
}


variable "azurerm_user_assigned_identity" {
  type = string
  description = "(required) will be used for app gateway"
}


######### HubNetwork subnet id

variable "hubnetwork_devops_subnetID" {
  type = string
  description = "HUb Network Azure DevOps agent deployed Subnet ID"
}



variable "dns_records" {
    type = any
}

variable "dns_zone_name" {
    type = string
}


variable "azurerm_cognitive_accounts" {
    type = any
}

variable "app_service_environment" {
    type = any
}
/*
variable "app_service_environment_cluster_setting" {
    type = object({
        name = string   
        value = string 
    })
    default = {
        "name" = "DisableTls1.0"
        "value" = "1"
    }
}
*/

variable "app_service_plan" {
    type = any
    description = "app service plan"
}

variable "app_service" {
    type = any
    description = "app service"
}