variable "subscription_id" {}
variable "environment" {}
variable "location" {}

# terraform {
#   backend "azurerm" {
#     resource_group_name  = "<storage-account-resource-group>"
#     storage_account_name = "<your-storage-account-name>"
#     subscription_id      = "<storage-account-subscription-id>"
#     container_name       = "tfstate"
#     key                  = "XXXX.tfstate"
#     use_azuread_auth     = true # Use Azure AD to authenticate, so if you are logged in with az cli, az account list, az login
#   }
# }

locals {
    common_tags = {
        common_tag = "common_tag_value"
    }
}

module "whatever-this-module-is" {
  #source               = "git@github.com:Djongov/terraform-azure-template.git?ref=main"
  source                = "../"
  environment           = var.environment
  location              = var.location
  subscription_id       = var.subscription_id
  common_tags           = local.common_tags
  #resource_group_name = var.resource_group_name
}