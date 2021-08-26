// Providers
variable "deployment_tags" {
  type        = map(string)
  description = "(Optional) Tags for deployment"
  default     = {}
}

variable "resource_tags" {
  type        = map(string)
  description = "(Optional) Tags for resources"
  default     = {}
}

variable "client_id" {
  type    = string
  default = ""
}

variable "client_secret" {
  type    = string
  default = ""
}

variable "subscription_id" {
  type    = string
  default = ""
}

variable "tenant_id" {
  type    = string
  default = ""
}
//**********************************************************************************************
######################## KeyVault#####################


variable "Keyvault" {
  type        = any
  description = "Azure Key Vaults details"
  default     = {}
}

variable "fileshare" {
  type    = any
  default = {}
}

/*
variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "Environment" {}

*/
// Tags
//**********************************************************************************************

/*



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
variable "aks_nsg_name" {
  type        = string
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

variable "aks_security_rule" {
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

variable "aks_subnetname" {
    type = string
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
variable "aks_subnet_cidr" {
    type = list
}

variable "kubernetes_tags" {
  default = {
    version = "1.20.5"
  }
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

variable "aks_user_assigned_identity" {
  type = string
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


variable "app_service_plan" {
    type = any
    description = "app service plan"
}

variable "app_service" {
    type = any
    description = "app service"
}

#############       AKS    #################

variable "kubernetes_version" {
  type        = string
  description = "(Optional) Version of Kubernetes specified when creating the AKS managed cluster"
  default     = "1.20.7"
}

variable "aks_name" {
  type        = string
  description = "(Required) The name of the Managed Kubernetes Cluster to create"
  default     = "opengov-aks"
}

variable "aks_dns_prefix" {
  type        = string
  description = "(Required) DNS prefix specified when creating the managed cluster"
  default     = "tfaks"
}

variable "application_node_pool" {
  description = "A application_node_pool block, see terraform.io/docs/providers/azurerm/r/kubernetes_cluster.html#default_node_pool"
  type = object({
    name                  = string       # (Required) The name which should be used for the default Kubernetes Node Pool
    vm_size               = string       #(Required) The size of the Virtual Machine, such as Standard_DS2_v2
    availability_zones    = list(string) #(Optional) A list of Availability Zones across which the Node Pool should be spread
    enable_node_public_ip = bool         #(Optional) Should nodes in this Node Pool have a Public IP Address? Defaults to false
    max_pods              = number       #Optional) The maximum number of pods that can run on each agent
    node_labels           = map(string)  #(Optional) A map of Kubernetes labels which should be applied to nodes in the Default Node Pool
    node_taints           = list(string) #(Optional) A list of Kubernetes taints which should be applied to nodes in the agent pool
    os_disk_size_gb       = number       #(Optional) The size of the OS Disk which should be used for each agent in the Node Pool
    os_disk_type          = string
    node_count            = number       #(Optional) The initial number of nodes which should exist in this Node Pool
    orchestrator_version  = string       #(Optional) Version of Kubernetes used for the Agents
    tags                  = map(string)  #(Optional) A mapping of tags to assign to the Node Pool

  })
  default = {
    name                  = "application_node_pool"
    vm_size               = "standard_f2"
    availability_zones    = null #[]
    enable_node_public_ip = false
    max_pods              = null
    node_labels           = {"use":"application"} #{}
    node_taints           = null #[]
    os_disk_size_gb       = null
    os_disk_type          = "Ephemeral"
    node_count            = null
    orchestrator_version  = null
    tags                  = null #{}
  }
}

variable "application_node_pool_scaling" {
  type = object({
    enable_auto_scaling = bool   #(Optional) Should the Kubernetes Auto Scaler be enabled for this Node Pool? Defaults to false
    min_count           = number #(Required) The maximum number of nodes which should exist in this Node Pool
    max_count           = number #(Required) The minimum number of nodes which should exist in this Node Pool.
  })
  description = "(Optional) Should the Kubernetes Auto Scaler be enabled for the Node Pool?"
  default = {
    enable_auto_scaling = false
    min_count           = null
    max_count           = null
  }
}
#################################################################################
variable "system_node_pool" {
  description = "A system_node_pool block, see terraform.io/docs/providers/azurerm/r/kubernetes_cluster.html#default_node_pool"
  type = object({
    name                  = string       # (Required) The name which should be used for the default Kubernetes Node Pool
    vm_size               = string       #(Required) The size of the Virtual Machine, such as Standard_DS2_v2
    availability_zones    = list(string) #(Optional) A list of Availability Zones across which the Node Pool should be spread
    enable_node_public_ip = bool         #(Optional) Should nodes in this Node Pool have a Public IP Address? Defaults to false
    max_pods              = number       #Optional) The maximum number of pods that can run on each agent
    node_labels           = map(string)  #(Optional) A map of Kubernetes labels which should be applied to nodes in the Default Node Pool
    node_taints           = list(string) #(Optional) A list of Kubernetes taints which should be applied to nodes in the agent pool
    os_disk_size_gb       = number       #(Optional) The size of the OS Disk which should be used for each agent in the Node Pool
    os_disk_type          = string
    type                  = string       #(Optional) The type of Node Pool which should be created. Possible values are AvailabilitySet and VirtualMachineScaleSets
    node_count            = number       #(Optional) The initial number of nodes which should exist in this Node Pool
    orchestrator_version  = string       #(Optional) Version of Kubernetes used for the Agents
    tags                  = map(string)  #(Optional) A mapping of tags to assign to the Node Pool

  })
  default = {
    name                  = "system_node_pool"
    vm_size               = "standard_f2"
    availability_zones    = null #[]
    enable_node_public_ip = false
    max_pods              = null
    node_labels           = {"use":"system"} #{}
    node_taints           = null #[]
    os_disk_size_gb       = null
    type                  = "VirtualMachineScaleSets"
    os_disk_type          = "Ephemeral"
    node_count            = null
    orchestrator_version  = null
    tags                  = null #{}
  }
}

variable "system_node_pool_scaling" {
  type = object({
    enable_auto_scaling = bool   #(Optional) Should the Kubernetes Auto Scaler be enabled for this Node Pool? Defaults to false
    min_count           = number #(Required) The maximum number of nodes which should exist in this Node Pool
    max_count           = number #(Required) The minimum number of nodes which should exist in this Node Pool.
  })
  description = "(Optional) Should the Kubernetes Auto Scaler be enabled for the Node Pool?"
  default = {
    enable_auto_scaling = false
    min_count           = null
    max_count           = null
  }
}

##################################################################
variable "management_node_pool" {
  description = "A management_node_pool block, see terraform.io/docs/providers/azurerm/r/kubernetes_cluster.html#default_node_pool"
  type = object({
    name                  = string       # (Required) The name which should be used for the default Kubernetes Node Pool
    vm_size               = string       #(Required) The size of the Virtual Machine, such as Standard_DS2_v2
    availability_zones    = list(string) #(Optional) A list of Availability Zones across which the Node Pool should be spread
    enable_node_public_ip = bool         #(Optional) Should nodes in this Node Pool have a Public IP Address? Defaults to false
    max_pods              = number       #Optional) The maximum number of pods that can run on each agent
    node_labels           = map(string)  #(Optional) A map of Kubernetes labels which should be applied to nodes in the Default Node Pool
    node_taints           = list(string) #(Optional) A list of Kubernetes taints which should be applied to nodes in the agent pool
    os_disk_size_gb       = number       #(Optional) The size of the OS Disk which should be used for each agent in the Node Pool
    os_disk_type          = string
    node_count            = number       #(Optional) The initial number of nodes which should exist in this Node Pool
    orchestrator_version  = string       #(Optional) Version of Kubernetes used for the Agents
    tags                  = map(string)  #(Optional) A mapping of tags to assign to the Node Pool

  })
  default = {
    name                  = "management_node_pool"
    vm_size               = "standard_f2"
    availability_zones    = null #[]
    enable_node_public_ip = false
    max_pods              = null
    node_labels           = {"use":"management"} #{}
    node_taints           = null #[]
    os_disk_size_gb       = null
    os_disk_type          = "Ephemeral"
    node_count            = null
    orchestrator_version  = null
    tags                  = null #{}
  }
}

variable "management_node_pool_scaling" {
  type = object({
    enable_auto_scaling = bool   #(Optional) Should the Kubernetes Auto Scaler be enabled for this Node Pool? Defaults to false
    min_count           = number #(Required) The maximum number of nodes which should exist in this Node Pool
    max_count           = number #(Required) The minimum number of nodes which should exist in this Node Pool.
  })
  description = "(Optional) Should the Kubernetes Auto Scaler be enabled for the Node Pool?"
  default = {
    enable_auto_scaling = false
    min_count           = null
    max_count           = null
  }
}

#######################################################################################################
# Networking
variable "network_profile" {
  type = map(object({
    network_plugin     = string #(Required) Network plugin to use for networking
    network_policy     = string #(Optional) Sets up network policy to be used with Azure CNI
    dns_service_ip     = string #(Optional) IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns)
    docker_bridge_cidr = string #(Optional) IP address (in CIDR notation) used as the Docker bridge IP address on nodes
    pod_cidr           = string #(Optional) The CIDR to use for pod IP addresses. This field can only be set when network_plugin is set to kubenet
    service_cidr       = string #(Optional) The Network Range used by the Kubernetes service
    outbound_type      = string #(Optional) The outbound (egress) routing method which should be used for this Kubernetes Cluster
    load_balancer_sku  = string #(Optional) Specifies the SKU of the Load Balancer used for this Kubernetes Cluster
    #load_balancer_profile = object({})
  }))
  description = "(Optional) Variables defining the AKS network profile config"
  default     = {}
}
variable "private_cluster_enabled" {
  type        = bool
  description = "(Optional) Should this Kubernetes Cluster have it's API server only exposed on internal IP addresses?"
  default     = false
}
########################################################################################################



########################################################################
# Authentication and Authorization
variable "rbac_enabled" {
  type        = bool
  description = "(Optional) Enable/Disable role based access control on AKS cluter"
  default     = false
}
variable "azure_active_directory" {
  type = map(object({
    managed                = bool         #(Optional)Is the Azure Active Directory integration Managed
    admin_group_object_ids = list(string) #(Optional) A list of Object IDs of Azure Active Directory Groups which should have Admin Role on the Cluster
    client_app_id          = string       #(Required) The Client ID of an Azure Active Directory Application
    server_app_id          = string       #(Required) The Server ID of an Azure Active Directory Application
    server_app_secret      = string       #(Required) The Server Secret of an Azure Active Directory Application
    tenant_id              = string       #(Optional) The Tenant ID used for Azure Active Directory Application
  }))
  description = "(Optional) Configure Kubernetes (RBAC) based on a user's identity or directory group membership in Azure AD"
  default     = {}
}
variable "identity" {
  type = map(object({
    type = string #(Required) The type of identity used for the managed cluster
  }))
  description = "(Optional) Managed Identity to interact with Azure APIs"
  default     = {}
}
/*
variable "service_principal" {
  type = map(object({
    client_id     = string #(Required) The Client ID for the Service Principal
    client_secret = string #(Required) The Client Secret for the Service Principal.
  }))
  description = "(Optional) Service principle to interact with Azure APIs"
  default     = {}
}

variable "linux_profile" {
  type = map(object({
    admin_username = string #(Required) The Admin Username for the Cluster
    ssh_key = object({
      key_data = string #(Required) The Public SSH Key used to access the cluster
    })
  }))
  description = "(Optional) SSH authentication parameter values"
  default     = {}
}

# Add-on profile
variable "addon_profile_oms_agent" {
  type = object({
    enabled                    = bool   #(Required) Is the OMS Agent Enabled?
    log_analytics_workspace_id = string #(Optional) The ID of the Log Analytics Workspace which the OMS Agent should send data to.
    #oms_agent_identity
  })
  description = "(Optional) Send AKS logs to OMS/Log Analytics Workspace"
  default = {
    enabled                    = false
    log_analytics_workspace_id = null
  }
}
variable "addon_profile_http_application_routing" {
  type = object({
    enabled = bool #(Required) Is HTTP Application Routing Enabled?
  })
  description = "TBD"
  default = {
    enabled = false
  }
}
*/
//**********************************************************************************************