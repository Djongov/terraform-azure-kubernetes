resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = {
    for app in local.apps_flat : "${app.namespace}-${app.app_name}" => app
  }

  name                  = substr("${each.value.namespace}${each.value.app_name}", 0, 12) # 12 letters max
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this[0].id
  vm_size               = each.value.node.vm_size
  node_count            = each.value.node.node_count
  min_count             = each.value.node.auto_scaling_enabled != null && each.value.node.min_count != null ? each.value.node.min_count : null
  max_count             = each.value.node.auto_scaling_enabled != null && each.value.node.max_count != null ? each.value.node.max_count : null
  auto_scaling_enabled  = each.value.node.auto_scaling_enabled != null ? each.value.node.auto_scaling_enabled : false
  vnet_subnet_id        = var.vnet_subnet_id != null ? var.vnet_subnet_id : azurerm_subnet.this[0].id

  temporary_name_for_rotation = "${each.value.namespace}temp"

  upgrade_settings {
    drain_timeout_in_minutes      = 0
    max_surge                     = "10%"
    node_soak_duration_in_minutes = 0
  }

  # Taint the node pool so only pods with a matching toleration can run here.
  node_taints = [
    "app=${each.value.app_name}:NoSchedule"
  ]
}
