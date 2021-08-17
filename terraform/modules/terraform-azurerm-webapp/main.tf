/*
resource "azurerm_app_service_environment" "ase" {
  name                         = var.app_service_environment.name
  subnet_id                    = data.azurerm_subnet.ase.id
  pricing_tier                 = var.app_service_environment.pricing_tier
  front_end_scale_factor       = var.app_service_environment.front_end_scale_factor
  internal_load_balancing_mode = var.app_service_environment.internal_load_balancing_mode
  allowed_user_ip_cidrs        = var.app_service_environment.allowed_user_ip_cidrs

  dynamic "cluster_setting" {
    for_each = var.cluster_setting
    content{
      name  = cluster_setting.value.name
      value = cluster_setting.value.value
    }
  }
    tags       = merge(var.resource_tags, var.deployment_tags)

}

*/
resource "azurerm_app_service_plan" "asp" {
  name                = var.app_service_plan.name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = var.app_service_plan.kind
  reserved            = var.app_service_plan.reserved
  #app_service_environment_id = azurerm_app_service_environment.ase.id

  sku {
    tier = var.app_service_plan.sku_tier
    size = var.app_service_plan.sku_size
    capacity = var.app_service_plan.sku_capacity
  }

  tags       = merge(var.resource_tags, var.deployment_tags)
}

resource "azurerm_app_service" "appservice" {
  name                = var.app_service.name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.asp.id
  https_only          = var.app_service.https_only
  
  # site_config = var.site_config
  dynamic "site_config" {
    for_each = [var.app_service.site_config]
    content {
      always_on                 = lookup(site_config.value, "always_on", false)
      app_command_line          = lookup(site_config.value, "app_command_line", null)
      auto_swap_slot_name       = lookup(site_config.value, "auto_swap_slot_name", null)
      default_documents         = lookup(site_config.value, "default_documents", null)
      dotnet_framework_version  = lookup(site_config.value, "dotnet_framework_version", null)
      ftps_state                = lookup(site_config.value, "ftps_state", null)
      http2_enabled             = lookup(site_config.value, "http2_enabled", null)
      ip_restriction            = lookup(site_config.value, "ip_restriction", null)
      java_container            = lookup(site_config.value, "java_container", null)
      java_container_version    = lookup(site_config.value, "java_container_version", null)
      java_version              = lookup(site_config.value, "java_version", null)
      linux_fx_version          = lookup(site_config.value, "linux_fx_version", null)
      local_mysql_enabled       = lookup(site_config.value, "local_mysql_enabled", null)
      managed_pipeline_mode     = lookup(site_config.value, "managed_pipeline_mode", null)
      min_tls_version           = lookup(site_config.value, "min_tls_version", null)
      php_version               = lookup(site_config.value, "php_version", null)
      python_version            = lookup(site_config.value, "python_version", null)
      remote_debugging_enabled  = lookup(site_config.value, "remote_debugging_enabled", null)
      remote_debugging_version  = lookup(site_config.value, "remote_debugging_version", null)
      scm_type                  = lookup(site_config.value, "scm_type", null)
      use_32_bit_worker_process = lookup(site_config.value, "use_32_bit_worker_process", null)
      websockets_enabled        = lookup(site_config.value, "websockets_enabled", null)
      windows_fx_version        = lookup(site_config.value, "windows_fx_version", null)
      number_of_workers        = lookup(site_config.value, "number_of_workers", null)

      # dynamic "cors" {
      #   for_each = lookup(site_config.value, "cors", [])
      #   content {
      #     allowed_origins     = cors.value.allowed_origins
      #     support_credentials = lookup(cors.value, "support_credentials", null)
      #   }
      # }
    }
  }
  identity {
      type = "SystemAssigned"
  }

  app_settings = var.app_service.app_settings
  
  tags       = merge(var.resource_tags, var.deployment_tags)

}
/*
data "azurerm_subnet" "ase" {
  name                  = var.subnet_name
  resource_group_name   = var.resource_group_name
  virtual_network_name  = var.virtual_network_name
}
*/