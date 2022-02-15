# Create storage account
resource "azurerm_storage_account" "ik" {
    name                        = "ikstorageexample"
    resource_group_name         = azurerm_resource_group.ik.name
    location                    = "West US"
    account_tier                = "Standard"
    account_replication_type    = "LRS"
}

resource "azurerm_storage_container" "artifacts" {
    name = "artifacts"
    storage_account_name = azurerm_storage_account.ik.name
    container_access_type = "private"
}

data "azurerm_role_definition" "reader" {
  name = "Storage Blob Data Reader"
}

resource "azurerm_role_assignment" "web_artifact_storage" {
  scope              = azurerm_storage_account.ik.id
  role_definition_id = "${azurerm_storage_account.ik.id}${data.azurerm_role_definition.reader.id}"
  principal_id       = azurerm_linux_virtual_machine.web.identity[0].principal_id
}

resource "azurerm_role_assignment" "jenkins_artifact_storage" {
  scope              = azurerm_storage_account.ik.id
  role_definition_id = "${azurerm_storage_account.ik.id}${data.azurerm_role_definition.reader.id}"
  principal_id       = azurerm_linux_virtual_machine.jenkins.identity[0].principal_id
}
