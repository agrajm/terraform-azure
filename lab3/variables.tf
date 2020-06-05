variable "loc" {
    description = "Default Azure region"
    default     =   "westeurope"
}

variable "nsgRG" {
    default = "NSGsRGCitadelTerrform"
    description = "RG to hold NSGs for this lab"
}

variable "rg" {
    default = "lab3RGterraformcitadel"
    description = "Name of the Resource Group"
}

variable "tags" {
    type = map
    default     = {
        source  = "citadel"
        env     = "training"
    }
}

variable "webapplocs" {
  type = list
  default = []
}
