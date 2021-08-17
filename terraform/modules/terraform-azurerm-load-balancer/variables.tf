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
/*
variable "subnet_id" {
  type = string
  description = "(Optional) The ID of the Subnet which should be associated with the IP Configuration."
}
*/