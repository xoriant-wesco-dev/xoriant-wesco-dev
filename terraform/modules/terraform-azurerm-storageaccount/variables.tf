variable "name"{
    type = string
}
variable "account_tier"{
    type = string
}
variable "account_kind" {
    type = string
}
variable "account_replication_type"{
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
/*
variable "keyvault_id" {
  type = string
}

variable "key_name" {
  type = string
}
*/