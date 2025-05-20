# Here you can describe the provider configuration
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# provider "kubernetes" {
#  for_each = var.k8s_clusters

#   host                   = azurerm_kubernetes_cluster.this[each.key].kube_admin_config.0.host
#   client_certificate     = base64decode(azurerm_kubernetes_cluster.this[each.key].kube_admin_config.0.client_certificate)
#   client_key             = base64decode(azurerm_kubernetes_cluster.this[each.key].kube_admin_config.0.client_key)
#   cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.this[each.key].kube_admin_config.0.cluster_ca_certificate)
# }
