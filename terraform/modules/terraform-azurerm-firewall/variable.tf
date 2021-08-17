variable "name"{
    type = string
}

variable "location"{
    type = string
}
variable "resource_group_name"{
    type = string
}
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

variable "subnet_cidr" {
  type = list(string)
  description = "The CIDR Subnet range for firewall"
}

variable "vnet_name" {
    type = string
  description = "The name of the Virtual Network to which firwall subnet need to be created."
}

variable "domain_name_label"{
    type = string
    description = "dns name for publi ip of firewall"
}

variable "additional_pips" {
  type = any
  description = "The name of the Virtual Network to which firwall subnet need to be created."
}
