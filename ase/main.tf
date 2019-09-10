provider "azurerm" {
}

resource "azurerm_resource_group" "main" {
  name     = var.rgName
  location = var.location
  tags     = var.tags
}

#Vnet to deploy resources in
resource "azurerm_virtual_network" "main" {
  name                = var.vNetName
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.vNetAddressSpace

  tags = azurerm_resource_group.main.tags

  # App GW subnet
  subnet {
    name           = var.appGWSubnetName
    address_prefix = var.appGWSubnetRange
  }

  # APIM Subnet
  subnet {
    name           = var.apimSubnetName
    address_prefix = var.apimSubnetRange
  }
}

# ASE Subnet
resource "azurerm_subnet" "ase" {
   name                       =  var.aseSubnetName
   address_prefix             =  var.aseSubnetRange
   virtual_network_name       =  azurerm_virtual_network.main.name
   resource_group_name        =  azurerm_resource_group.main.name
}


# ASE Subnet NSG required for Inbound and Outbound traffic
resource "azurerm_network_security_group" "asensg" {
   name                 =  "ase-nsg"
   location             =  azurerm_resource_group.main.location
   resource_group_name  =  azurerm_resource_group.main.name

   security_rule {
      name                       = "Inbound-management"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "454-455"
      source_address_prefix      = "AppServiceManagement"
      destination_address_prefix = "*"
   }

   security_rule {
      name                       = "Inbound-load-balancer-keep-alive"
      priority                   = 105
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "16001"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
   }

   security_rule {
      name                       = "ASE-internal-inbound"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = var.aseSubnetRange
      destination_address_prefix = "*"
   }

   security_rule {
      name                       = "Inbound-HTTP"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
   }

   security_rule {
      name                       = "Inbound-HTTPS"
      priority                   = 130
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
   }

   security_rule {
      name                       = "Outbound-DNS"
      priority                   = 110
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
   }

   security_rule {
      name                       = "ASE-internal-outbound"
      priority                   = 120
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = var.aseSubnetRange
   }

   security_rule {
      name                       = "ASE-to-VNET"
      priority                   = 130
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = azurerm_virtual_network.main.address_space[0]
   }

   security_rule {
      name                       = "Outbound-NTP"
      priority                   = 140
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "123"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
   }
  
}

#ASE Subnet NSG Association 
resource "azurerm_subnet_network_security_group_association" "asensgasc" {
   subnet_id                  =  azurerm_subnet.ase.id
   network_security_group_id  =  azurerm_network_security_group.asensg.id
}

# ILB ASE v2
resource "azurerm_template_deployment" "deployASE" {
  name                = "aseDeployment"
  resource_group_name = azurerm_resource_group.main.name

  template_body = <<DEPLOY
  {
   "$schema":"https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json",
   "contentVersion":"1.0.0.0",
   "parameters":{
      "aseName":{
         "type":"string",
         "metadata":{
            "description":"Name of the App Service Environment"
         }
      },
      "aseLocation":{
         "type":"string",
         "defaultValue":"South Central US",
         "metadata":{
            "description":"Location of the App Service Environment"
         }
      },
      "existingVirtualNetworkName":{
         "type":"string",
         "metadata":{
            "description":"Name of the existing VNET"
         }
      },
      "existingVirtualNetworkResourceGroup":{
         "type":"string",
         "metadata":{
            "description":"Name of the existing VNET resource group"
         }
      },
      "subnetName":{
         "type":"string",
         "metadata":{
            "description":"Subnet name that will contain the App Service Environment"
         }
      },
      "internalLoadBalancingMode":{
         "type":"string",
         "metadata":{
            "description":"Specifies which endpoints to serve internally in the Virtual Network for the App Service Environment. - None, Web, Publishing"
         }
      },
      "dnsSuffix":{
         "type":"string",
         "metadata":{
            "description":"Used *only* when deploying an ILB enabled ASE.  Set this to the root domain associated with the ASE.  For example: contoso.com"
         }
      }
   },
   "variables":{
      "vnetID":"[resourceId(parameters('existingVirtualNetworkResourceGroup'), 'Microsoft.Network/virtualNetworks', parameters('existingVirtualNetworkName'))]"
   },
   "resources":[
      {
         "apiVersion":"2016-09-01",
         "type":"Microsoft.Web/hostingEnvironments",
         "name":"[parameters('aseName')]",
         "kind":"ASEV2",
         "location":"[parameters('aseLocation')]",
         "properties":{
            "name":"[parameters('aseName')]",
            "location":"[parameters('aseLocation')]",
            "ipSslAddressCount":0,
            "internalLoadBalancingMode":"[parameters('internalLoadBalancingMode')]",
            "dnsSuffix":"[parameters('dnsSuffix')]",
            "virtualNetwork":{
               "Id":"[variables('vnetID')]",
               "Subnet":"[parameters('subnetName')]"
            }
         }
      }
    ],
    "outputs": {
      "app_service_evironment_id": {
        "type": "string",
        "value": "[resourceId('Microsoft.Web/hostingEnvironments', parameters('aseName'))]"
      }
    } 
  }
   DEPLOY


  # these key-value pairs are passed into the ARM Template's `parameters` block
  parameters = {
    "aseName"                             = var.aseName
    "aseLocation"                         = azurerm_resource_group.main.location
    "existingVirtualNetworkName"          = azurerm_virtual_network.main.name
    "existingVirtualNetworkResourceGroup" = azurerm_resource_group.main.name
    "subnetName"                          = var.aseSubnetName
    "internalLoadBalancingMode"           = var.internalLoadBalancingMode
    "dnsSuffix"                           = var.dnsSuffixASE
  }

  deployment_mode = "Incremental"
}

# App Service Plan
resource "azurerm_app_service_plan" "asp" {
  name                       = "webapps-appserviceplan"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  kind                       = "Linux"
  reserved                   = true
  app_service_environment_id = azurerm_template_deployment.deployASE.outputs["app_service_evironment_id"]

  sku {
    tier = "Isolated"
    size = "S1"
  }
}

