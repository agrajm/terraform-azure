variable "rg" {
  default = "stgacclab2RG"
  description = "the resource group"
}

variable "loc" {
  default = "australiasoutheast"
  description = "the location to create resources in"
}

variable "tags" {
  type = map
  default = {
      environment = "training"
      speciality = "terraform"
  }
  description = "common set of tags to put on every resource"
}


