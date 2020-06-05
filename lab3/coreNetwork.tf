provider "azurerm" {
  version = "=2.5.0"
  features {}
}

resource "azurerm_resource_group" "core" {
  name = "core"
  location = var.loc
  tags = var.tags
}

resource "azurerm_public_ip" "vpnGatewayPublicIp" {
  name                = "vpnGatewayPublicIp"
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
  allocation_method   = "Dynamic"

  tags = azurerm_resource_group.core.tags
}

resource "azurerm_virtual_network" "core" {
  name                = "coreVNet"
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
  address_space       = ["10.0.0.0/24"]
  dns_servers         = ["1.1.1.1", "1.0.0.1"]

  tags = azurerm_resource_group.core.tags
}

resource "azurerm_subnet" "GatewaySubnet" {
   name                 = "GatewaySubnet"
   resource_group_name  = azurerm_resource_group.core.name
   virtual_network_name = azurerm_virtual_network.core.name

   address_prefix       = "10.0.0.0/26"
}

resource "azurerm_subnet" "training" {
   name                 = "trainingSubnet"
   resource_group_name  = azurerm_resource_group.core.name
   virtual_network_name = azurerm_virtual_network.core.name

   address_prefix       = "10.0.1.0/26"
}

resource "azurerm_subnet" "dev" {
   name                 = "dev"
   resource_group_name  = azurerm_resource_group.core.name
   virtual_network_name = azurerm_virtual_network.core.name

   address_prefix       = "10.0.2.0/26"
}

# resource "azurerm_virtual_network_gateway" "vpnGateway" {
#   name                = "vpnGateway"
#   location            = azurerm_resource_group.core.location
#   resource_group_name = azurerm_resource_group.core.name
#   tags = azurerm_resource_group.core.tags

#   type     = "Vpn"
#   vpn_type = "RouteBased"

#   enable_bgp    = true
#   sku           = "Basic"

#   ip_configuration {
#     name                          = "vpnGwConfig1"
#     public_ip_address_id          = azurerm_public_ip.vpnGatewayPublicIp.id
#     private_ip_address_allocation = "Dynamic"
#     subnet_id                     = azurerm_subnet.GatewaySubnet.id
#   }
# }