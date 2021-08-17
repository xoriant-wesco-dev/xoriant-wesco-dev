resource "azurerm_network_interface" "myterraformnic" {
    name                      = "${var.vmname}-nic"
    location                  =  var.location
    resource_group_name       = var.resource_group_name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = var.subnet_id
        private_ip_address_allocation = "Dynamic"
        #public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
    }

    tags       = merge(var.resource_tags, var.deployment_tags)
}


resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = var.resource_group_name
    }

    byte_length = 8
}

resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = var.resource_group_name
    location                    =  var.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags       = merge(var.resource_tags, var.deployment_tags)
}


resource "azurerm_linux_virtual_machine" "myterraformvm" {
    name                  = var.vmname
    location              = var.location
    resource_group_name   = var.resource_group_name
    network_interface_ids = [azurerm_network_interface.myterraformnic.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "devops"
    admin_username = "avayaadmin"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "avayaadmin"
        public_key     = var.vm_publickey
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

    tags       = merge(var.resource_tags, var.deployment_tags)
}