# Create virtual machine
resource "azurerm_linux_virtual_machine" "jenkins" {
    name                  = "ik-jenkins"
    location              = "West US"
    resource_group_name   = azurerm_resource_group.ik.name
    network_interface_ids = [azurerm_network_interface.jenkins.id]
    size                  = "Standard_DS1_v2"
    identity {
        type = "SystemAssigned"
    }

    os_disk {
        name              = "JenkinsOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-focal"
        sku       = "20_04-lts"
        version   = "latest"
    }

    computer_name  = "ik-jenkins"
    admin_username = "azureuser"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "azureuser"
        public_key     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDolr23hwJ6qrb++iTMu2is5ugnEtI7byjcicR4amEmDALBq9bGIcxpIayy0xpnUhlfCFeaBp666ds1JAdKA4tuwa/+Qt+v3ZnQWHCzPx5afyP75VXfT9qRMopeRrrUZ0fU33gS4oaDWj6/wWoXaunxsUMhh3/W4afNyc1zuSjNeIYOTxPk4UIAON9RzXaHTMollStAdieQgR5eJt4I94/kGJz9gWb0EnjeGmf9GsLf5Evs8jC7+H9QF0j1mcQvva4wKmSakl7zp0vd3CUylKCZTNNAXgsCxdWyEw8O4aZ8aHhx8OBxCoagUHdTukLt8cr2ERep2WBJtKBfFy2m6kDL diogenes@macbook-pro.lan"
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.ik.primary_blob_endpoint
    }
}