# Here you will place data resources that you want to use in your Terraform configuration.
data "azurerm_client_config" "current" {}

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

data "azurerm_key_vault" "default" {
  count = var.k8s_cluster.key_vault_access != null ? 1 : 0

  name                = split("/", var.k8s_cluster.key_vault_access.key_vault_id)[8]
  resource_group_name = split("/", var.k8s_cluster.key_vault_access.key_vault_id)[4]
}

# data "azurerm_key_vault_certificate" "tls" {
#   for_each = {
#     for cert in var.k8s_cluster.ssl_certificates : cert.certificate_name => cert if cert.key_vault_id != null
#   }

#   name         = each.value.certificate_name
#   key_vault_id = data.azurerm_key_vault.default[0].id
# }

# output "pfx_blob" {
#   value = {
#     for cert in data.azurerm_key_vault_certificate.tls : cert.key_vault_id => {
#       certificate_name = cert.name
#       pfx_blob         = cert.certificate_data_base64
#       key_vault_id     = cert.key_vault_id
#     }
#   }
#   description = "PFX blobs for the certificates stored in Key Vault"
# }
