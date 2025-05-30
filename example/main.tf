variable "subscription_id" {}
variable "environment" {}
variable "location" {}
variable "k8s_clusters" { default = {} }

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
  project_name = "sunwell-k8s"
  repo_name    = "terraform-azure-kubernetes"
}

module "whatever-this-module-is" {
  #source               = "git@github.com:Djongov/terraform-azure-kubernetes.git?ref=main"
  source          = "../"
  project_name    = local.project_name
  environment     = var.environment
  location        = var.location
  subscription_id = var.subscription_id
  common_tags     = local.common_tags
  repo_name       = local.repo_name
  #k8s_clusters          = local.k8s_clusters_by_env[var.environment]
}

# module "networking-module" {
#   source                = "../terraform-azure-networking"
# }
