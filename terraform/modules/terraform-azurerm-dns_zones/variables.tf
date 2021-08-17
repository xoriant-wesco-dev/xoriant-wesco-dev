variable "dns_zone_name" {
    type = string
}

variable "resource_group_name" {
    type = string
}

variable "dns_records" {
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