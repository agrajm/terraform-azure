variable "location" {
  description = "Location to create Resources in"
  default = "australiasoutheast"
}

variable "rgName" {
  default = "ASE_APIM_APPGW_test"
  description = "Resource Group to create Resources in "
}

variable "tags" {
  description = "tags associated with resources"
  default = {
    env = "dev"
    org = "contoso"
  }
}

variable "vNetName" {
  description = "Name of the virtual network to deploy resources in"
  default = "virtualNetworkWebApps"
}

variable "vNetAddressSpace" {
  description = "Address Space for Virtual Network"
  default = ["10.0.0.0/16"]
}

variable "appGWSubnetName" {
  description = "Name of App Gateway Subnet"
  default = "APPGW_Subnet"
}

variable "appGWSubnetRange" {
  description = "Address Range for App Gateway Subnet"
  default = "10.0.1.0/27"
}

variable "aseSubnetName" {
  description = "Name of the App Service Environment subnet"
  default = "ASE_Subnet"
}

variable "aseSubnetRange" {
  default = "10.0.0.0/24"
  description = "Address Range for App Service Environment subnet"
}

variable "aseName" {
  description = "Name of the App Service Environment"
  default = "ILBASEv2webapps"
}

variable "dnsSuffixASE" {
  description = "DNS Suffix for ASE"
  default = "contoso.com"
}

variable "internalLoadBalancingMode" {
  description = "Specifies which endpoints to serve internally in the Virtual Network for the App Service Environment - None, Web, Publishing"
  default = "Web"
}


variable "apimSubnetName" {
  description = "Name of the API Management subnet"
  default = "APIM_Subnet"
}

variable "apimSubnetRange" {
  default = "10.0.2.0/27"
  description = "Address Range for API Management subnet"
}
