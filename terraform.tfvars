resource_tags = {
  version = "1.0"
}

deployment_tags = {
  environment      = "development"
  region           = "eastus"
  Compliance       = "Not_Applicable"
  DRProtected      = "No"
  Creator          = "SLakhey@xyz.com"
  CloudOwner       = "arizvi@xyz.com"
  ApplicationName  = "LIBAV"
  BusinessOwner    = "sshankaran@xyz.com"
  ApplicationOwner = "pchawla@xyz.com"
}

fileshare = {
  resource_grp_name        = "SampleResourceGroup1"
  location                 = "eastus"
  name                     = "xordevfilesharepoc"
  account_tier             = "premium"
  account_replication_type = "LRS"
  account_kind             = "FileStorage"
}
/*
Keyvault = {
  name                            = "xor-dev-keyvault-poc"
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  sku_name                        = "premium"
  soft_delete_enabled             = true
  soft_delete_retention_days      = 10
  purge_protection_enabled        = false
  resource_grp_name               = "SampleResourceGroup1"
  location                        = "eastus"
}*/
