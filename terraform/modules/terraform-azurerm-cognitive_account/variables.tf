variable "azurerm_cognitive_accounts" {
    type = any
}

variable "resource_group_name" {
    type = string
}

variable "location" {
    type = any
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