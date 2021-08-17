// Required Variables
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network"
}

variable "location" {
  type        = string
  description = "(Required) The location/region where the virtual network is created"
}

variable "vmname" {
  type        = string
  description = "(Required) The name of the Virtual Machine"
}
variable "subnet_id" {
  type        = string
  description = "(Required) the subnet in which VM will be created"
}

variable "vm_publickey" {
    type = string
    description =  "(Required) Azure devops private agent VM Name ssh key"
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
