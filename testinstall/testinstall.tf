provider "azurerm" {
}
resource "azurerm_resource_group" "rg" {
        name = "testResourceGroup2"
        location = "eastus"
}