# Here you will place data resources that you want to use in your Terraform configuration.
# data "azurerm_client_config" "current" {}

#  # Get current user
# data "azuread_user" "current_user" {
#     object_id = data.azurerm_client_config.current.object_id
# }

# data "azurerm_container_registry" "acr" {
#   for_each = {
#     for k, v in var.k8s_clusters : k => v if v.acr_id != null
#   }

#   name                = split("/", each.value.acr_id)[8]
#   resource_group_name = split("/", each.value.acr_id)[4]
# }

data "azurerm_resource_group" "default" {
  name = var.resource_group_name
}
