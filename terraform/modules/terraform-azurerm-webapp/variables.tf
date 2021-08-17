variable "app_service_environment" {
    type = any
}

/*
variable "cluster_setting" {
    type = object({
        name = string   
        value = string 
    })
}
*/

variable "app_service_plan" {
    type = any
    description = "details of app service plan"
}

variable "app_service" {
    type = any
    description = "details of app service"
}

variable "resource_group_name" {
    type = string
    description = "app service vnet reosurce group"
}
/*
variable "virtual_network_name" {
    type = string
    description = "VNet in which app service environment to be created"
}

variable "subnet_name" {
    type = string
    description = "subnet in which app service environment to be created"
}
*/
variable "location" {
    type = string
    description = "location in which App service to be created"
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
