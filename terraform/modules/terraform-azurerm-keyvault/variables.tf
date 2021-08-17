variable "name"{
    type = string
}
variable "enabled_for_deployment"{
    type = bool
}
variable "enabled_for_disk_encryption"{
    type = bool
}
variable "enabled_for_template_deployment"{
    type = bool
}
variable "sku_name"{
    type = string
}
variable "soft_delete_enabled"{
    type = bool
}
variable "soft_delete_retention_days"{
    type = string
}
variable "purge_protection_enabled"{
    type = bool
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

variable "tenant_id"{
    type = string
}