resource "azurerm_role_assignment" "aks_keyvault_access" {
  count = var.k8s_cluster.key_vault_access.rbac_role != null ? 1 : 0

  scope                = var.k8s_cluster.key_vault_access.key_vault_id
  role_definition_name = var.k8s_cluster.key_vault_access.rbac_role
  principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}
