provider "azurerm" {
}

resource "azurerm_resource_group" "lab1" {
  name      = "terraformlab1RG"
  location  = "australiasoutheast"

  tags = {
    environment = "training"
  }
}

resource "azurerm_storage_account" "lab1_sa" {
    resource_group_name         = "${azurerm_resource_group.lab1.name}"
    name                        = "storageacctftestlab1am"
    location                    = "australiasoutheast"
    account_tier                = "Standard"
    account_replication_type    = "LRS"
}


