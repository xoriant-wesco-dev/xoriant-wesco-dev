variable "name"{
  type = string
}
variable "traffic_routing_method"{
  type = string
}
variable "resource_group_name"{
  type = string
}
variable "dnsname" {
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