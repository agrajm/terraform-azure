variable "loc" {
    description = "Default Azure region"
    default     =   "westeurope"
}

variable "tags" {
    default     = {
        source  = "citadel"
        env     = "training"
    }
}

variable "locs" {
  type = "list"
  default = [ "eastus2", "uksouth", "centralindia" ]
}
