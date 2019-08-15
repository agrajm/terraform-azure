variable "rg" {
  default = "stgacclab2RG"
  description = "the resource group"
}

variable "loc" {
  default = "eastus"
  description = "the location to create resources in"
}

variable "tags" {
  type = "map"
  default = {
      environment = "training"
      speciality = "variables"
  }
  description = "common set of tags to put on every resource"
}


