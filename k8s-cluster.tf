resource "azurerm_kubernetes_cluster" "this" {

  name                = "${var.project_name}-k8s-${var.environment}-${local.location_abbreviation}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.project_name}-k8s"

  default_node_pool {
    name           = "system"
    node_count     = var.k8s_cluster.default_node_pool.node_count
    vm_size        = var.k8s_cluster.default_node_pool.vm_size
    vnet_subnet_id = var.vnet_subnet_id

    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }

  dynamic "identity" {
    for_each = var.k8s_cluster.identity != null && length(var.k8s_cluster.identity) > 0 ? [var.k8s_cluster.identity] : []
    content {
      type = identity.value.type
    }
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  count = var.k8s_cluster.acr_id != null ? 1 : 0

  principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = var.k8s_cluster.acr_id
}

# Now add Network Contributor to the cluster managed identity over the resource group as it seems that it is required for the AKS to manage the public IP
resource "azurerm_role_assignment" "network_contributor" {
  count = var.k8s_cluster.public_ip != null ? var.k8s_cluster.public_ip == true ? 1 : 0 : 0

  principal_id         = azurerm_kubernetes_cluster.this.identity[0].principal_id
  role_definition_name = "Network Contributor"
  scope                = data.azurerm_resource_group.default.id
}

# resource "kubernetes_secret" "acr_pull" {
#   for_each = {
#     for k, v in var.k8s_clusters : k => v if v.acr_id != null
#   }
#   metadata {
#     name      = "acr-secret"
#     namespace = "default" # or your target namespace
#   }

#   type = "kubernetes.io/dockerconfigjson"

#   data = {
#     ".dockerconfigjson" = base64encode(jsonencode({
#       auths = {
#         "${data.azurerm_container_registry.acr[each.key].login_server}" = {
#           username = data.azurerm_container_registry.acr[each.key].admin_username
#           password = data.azurerm_container_registry.acr[each.key].admin_password
#           email    = "unused@example.com"
#           auth     = base64encode("${data.azurerm_container_registry.acr[each.key].admin_username}:${data.azurerm_container_registry.acr[each.key].admin_password}")
#         }
#       }
#     }))
#   }
# }

resource "helm_release" "nginx_ingress" {
  count = var.k8s_cluster.deploy_ingress ? 1 : 0

  name       = "nginx-ingress"
  namespace  = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.10.0"

  create_namespace = true

  values = [
    yamlencode({
      controller = {
        replicaCount = 2
        service = {
          type = "LoadBalancer"
        }
      }
    })
  ]
}

resource "azurerm_public_ip" "nginx_ingress" {
  count = var.k8s_cluster.public_ip != null ? var.k8s_cluster.public_ip == true ? 1 : 0 : 0

  name                = "${var.project_name}-nginx-public-ip-ingress-${var.environment}-${local.location_abbreviation}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge(
    local.common_tags
  )
}
