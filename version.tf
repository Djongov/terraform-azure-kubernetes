terraform {
  required_version = ">= 1.10.5" # or lock it to the 1.10.5 version by using ~> 1.10.5
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.14.0"
    }
  }
}