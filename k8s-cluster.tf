resource "azurerm_kubernetes_cluster" "this" {
  for_each = var.k8s_clusters

  name                = "${var.project_name}-k8s-${var.environment}-${local.location_abbreviation}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.project_name}-k8s"

  dynamic "default_node_pool" {
    for_each = var.k8s_clusters[each.key].default_node_pool != null ? [var.k8s_clusters[each.key].default_node_pool] : []
    content {
      name           = "system"
      node_count     = each.value.default_node_pool.node_count
      vm_size        = each.value.default_node_pool.vm_size
      vnet_subnet_id = each.value.default_node_pool.vnet_subnet_id

       upgrade_settings {
        drain_timeout_in_minutes = 0
        max_surge = "10%"
        node_soak_duration_in_minutes = 0
      }
    }
  }

  dynamic "identity" {
    for_each = var.k8s_clusters[each.key].identity != null ? [var.k8s_clusters[each.key].identity] : []
    content {
      type = each.value.identity.type
    }
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  for_each = {
    for k, v in var.k8s_clusters : k => v if v.acr_id != null
  }

  principal_id   = azurerm_kubernetes_cluster.this[each.key].identity[0].principal_id
  role_definition_name = "AcrPull"
  scope          = each.value.acr_id
}