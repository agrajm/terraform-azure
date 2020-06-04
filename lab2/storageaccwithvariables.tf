provider "azurerm" {
    version = "=2.5.0"
    features {}
}

resource "azurerm_resource_group" "lab2" {

    name    = var.rg
    location = var.loc
    tags = var.tags
}

resource "random_string" "rand" {
    length = 8
    special = false
    upper = false
    lower = true
    number = true
}

resource "azurerm_storage_account" "lab2" {
  
    name                = "sa${var.tags["speciality"]}${random_string.rand.result}"
    resource_group_name = azurerm_resource_group.lab2.name
    account_tier        = "Standard"
    account_replication_type = "LRS"
    location            = var.loc

    tags = var.tags
}

