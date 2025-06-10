# resource "azurerm_role_assignment" "aks_acr_pull" {
#   count                = var.acr_id != null ? 1 : 0
#   scope                = var.acr_id
#   role_definition_name = "AcrPull"
#   principal_id         = azurerm_kubernetes_cluster.this[0].identity[0].principal_id
# }

resource "azurerm_role_assignment" "aks_acr_pull" {
  count                = var.acr_id != null ? 1 : 0
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.this[0].kubelet_identity[0].object_id

  depends_on = [azurerm_kubernetes_cluster.this]
}

# Network Contributor for the AKS managed identity
resource "azurerm_role_assignment" "network_contributor" {
  principal_id         = azurerm_kubernetes_cluster.this[0].identity[0].principal_id
  role_definition_name = "Network Contributor"
  scope                = azurerm_virtual_network.this[0].id

  depends_on = [azurerm_kubernetes_cluster.this]
}

# resource "azurerm_user_assigned_identity" "aks_keyvault_identity" {
#   name                = "aks-keyvault-uami"
#   resource_group_name = var.resource_group_name
#   location            = var.location
# }

# resource "azurerm_role_assignment" "acr_pull" {
#   count = var.k8s_cluster.acr_id != null ? 1 : 0

#   principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
#   role_definition_name = "AcrPull"
#   scope                = var.k8s_cluster.acr_id
# }

resource "azurerm_role_assignment" "kv_secret_user" {
  scope                = var.k8s_cluster.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_kubernetes_cluster.this[0].key_vault_secrets_provider[0].secret_identity[0].object_id

  depends_on = [azurerm_kubernetes_cluster.this]
}

resource "azurerm_role_assignment" "kv_certificate_user" {
  scope                = var.k8s_cluster.key_vault_id
  role_definition_name = "Key Vault Certificate User"
  principal_id         = azurerm_kubernetes_cluster.this[0].key_vault_secrets_provider[0].secret_identity[0].object_id

  depends_on = [azurerm_kubernetes_cluster.this]
}


# # Now add Network Contributor to the cluster managed identity over the resource group as it seems that it is required for the AKS to manage the public IP
# resource "azurerm_role_assignment" "network_contributor" {
#   count = var.k8s_cluster.public_ip != null ? var.k8s_cluster.public_ip == true ? 1 : 0 : 0

#   principal_id         = azurerm_kubernetes_cluster.this.identity[0].principal_id
#   role_definition_name = "Network Contributor"
#   scope                = data.azurerm_resource_group.default.id

#   depends_on = [azurerm_kubernetes_cluster.this]
# }

# resource "azurerm_role_assignment" "aks_keyvault_access" {
#   count = var.k8s_cluster.key_vault_access.rbac_role != null ? 1 : 0

#   scope                = var.k8s_cluster.key_vault_access.key_vault_id
#   role_definition_name = var.k8s_cluster.key_vault_access.rbac_role
#   principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
# }
