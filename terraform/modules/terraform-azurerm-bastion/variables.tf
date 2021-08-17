// Required Variables
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network"
}

variable "location" {
  type        = string
  description = "(Required) The location/region where the virtual network is created"
}

variable "bastion_name" {
  type        = string
  description = "(Required) The name of the Virtual Machine"
}

variable "address_prefixes" {
  type        = list
  description = "bastion subnet address prefixes"
}

variable "virtual_network_name" {
  type        = string
  description = "Virtual name name for bastion service subnet"
}
variable "resource_tags" {
  type        = map(string)
  description = "(Optional) Tags for the resources"
  default     = {}
}

variable "deployment_tags" {
  type        = map(string)
  description = "(Optional) Additional Tags for the deployment"
  default     = {}
}
