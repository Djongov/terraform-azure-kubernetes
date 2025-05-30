output "kube_config" {
  value = length(var.k8s_cluster) > 0 ? azurerm_kubernetes_cluster.this[0].kube_config : null
  #sensitive = true
}

output "name" {
  value = azurerm_kubernetes_cluster.this[0].name
}
output "id" {
  value = azurerm_kubernetes_cluster.this[0].id
}
