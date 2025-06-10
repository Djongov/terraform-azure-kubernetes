resource "azurerm_kubernetes_cluster" "this" {
  count = var.k8s_cluster != null && length(var.k8s_cluster) > 0 ? 1 : 0

  name                = "${var.project_name}-aks-${var.environment}-${local.location_abbreviation}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.project_name}-aks"

  default_node_pool {
    name                        = "system"
    node_count                  = var.k8s_cluster.default_node_pool_node_count != null ? var.k8s_cluster.default_node_pool_node_count : 1
    vm_size                     = var.k8s_cluster.default_node_pool_vm_size != null ? var.k8s_cluster.default_node_pool_vm_size : "Standard_B4ms"
    vnet_subnet_id              = var.vnet_subnet_id != null ? var.vnet_subnet_id : azurerm_subnet.this[0].id
    temporary_name_for_rotation = "systemtemp"

    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  dynamic "web_app_routing" {
    for_each = var.k8s_cluster.ingress == "nginx" ? [1] : []
    content {
      dns_zone_ids = []
    }
  }

  network_profile {
    network_plugin = var.k8s_cluster.network_plugin != null ? var.k8s_cluster.network_plugin : "azure" # "azure", "kubenet", or "none"
    network_policy = var.k8s_cluster.network_policy != null ? var.k8s_cluster.network_policy : "azure" # calico, azure and cilium
    # Because network_plugin_mode can only be "overlay" as value when network_plugin is "azure", we can set it to "overlay" by default IF the network_plugin is "azure" and network_policy is "azure"
    network_plugin_mode = var.k8s_cluster.network_plugin == "azure" && var.k8s_cluster.network_policy == "azure" ? "overlay" : null
    load_balancer_sku   = "standard" # or "basic"
  }
  identity {
    type = "SystemAssigned"
    #type         = "UserAssigned"
    #identity_ids = [azurerm_user_assigned_identity.aks_keyvault_identity.id]
  }

  tags = merge(
    local.common_tags,
    var.k8s_cluster.tags != null ? var.k8s_cluster.tags : {}
  )
}

# resource "helm_release" "secrets_store_csi_driver" {
#   name       = "csi-secrets-store"
#   repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
#   chart      = "secrets-store-csi-driver"
#   version    = "1.5.1" # choose latest stable

#   namespace = "kube-system"

#   # Optional: override values if needed
#   values = [
#     yamlencode({
#       syncSecret = {
#         enabled = true
#       }
#     })
#   ]

#   depends_on = [azurerm_kubernetes_cluster.this]
# }

resource "kubernetes_namespace" "apps" {
  for_each = var.k8s_cluster.namespaces != null ? var.k8s_cluster.namespaces : {}

  metadata {
    name = each.key
  }

}



# resource "kubernetes_manifest" "ingress_tls_spc" {
#   manifest = {
#     apiVersion = "secrets-store.csi.x-k8s.io/v1"
#     kind       = "SecretProviderClass"
#     metadata = {
#       name      = "ingress-tls"
#       namespace = "ingress-nginx"
#     }
#     spec = {
#       provider = "azure"
#       parameters = {
#         usePodIdentity       = "false"
#         useVMManagedIdentity = "true"
#         #userAssignedIdentityID = azurerm_user_assigned_identity.aks_keyvault_identity.client_id
#         keyvaultName = var.k8s_cluster.key_vault_access.key_vault_id != null ? split("/", var.k8s_cluster.key_vault_access.key_vault_id)[8] : ""
#         tenantId     = data.azurerm_client_config.current.tenant_id
#         objects      = <<EOT
# array:
#   - |
#     objectName: diablo-2-wildcard
#     objectType: secret
# EOT
#       }
#     }
#   }
# }

# resource "helm_release" "nginx_ingress" {
#   count = var.k8s_cluster.deploy_ingress ? 1 : 0

#   name       = "nginx-ingress"
#   namespace  = "ingress-nginx"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   version    = "4.10.0"

#   create_namespace = true

#   values = [
#     yamlencode({
#       controller = {
#         replicaCount = 1
#         service = {
#           type = "LoadBalancer"
#         }
#       }
#     })
#   ]
# }

# # resource "helm_release" "nginx_ingress" {
# #   count = var.k8s_cluster.deploy_ingress ? 1 : 0

# #   name       = "nginx-ingress"
# #   namespace  = "ingress-nginx"
# #   repository = "https://kubernetes.github.io/ingress-nginx"
# #   chart      = "ingress-nginx"
# #   version    = "4.10.0"

# #   create_namespace = true

# #   values = [
# #     yamlencode({
# #       controller = {
# #         replicaCount = 2
# #         service = {
# #           type = "LoadBalancer"
# #         }

# #         extraVolumes = [
# #           {
# #             name = "secrets-store-inline"
# #             csi = {
# #               driver   = "secrets-store.csi.k8s.io"
# #               readOnly = true
# #               volumeAttributes = {
# #                 secretProviderClass = "ingress-tls"
# #               }
# #             }
# #           }
# #         ]

# #         extraVolumeMounts = [
# #           {
# #             name      = "secrets-store-inline"
# #             mountPath = "/mnt/secrets-store"
# #             readOnly  = true
# #           }
# #         ]
# #       }
# #     })
# #   ]
# # }


# resource "azurerm_public_ip" "nginx_ingress" {
#   count = var.k8s_cluster.public_ip != null ? var.k8s_cluster.public_ip == true ? 1 : 0 : 0

#   name                = "${var.project_name}-nginx-public-ip-ingress-${var.environment}-${local.location_abbreviation}"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   allocation_method   = "Static"
#   sku                 = "Standard"

#   tags = merge(
#     local.common_tags
#   )
# }



# # https://github.com/Azure/secrets-store-csi-driver-provider-azure/releases
# resource "helm_release" "azure_secrets_provider" {
#   name       = "csi-secrets-store-provider-azure"
#   namespace  = "kube-system"
#   repository = "https://azure.github.io/secrets-store-csi-driver-provider-azure/charts"
#   chart      = "csi-secrets-store-provider-azure"
#   version    = "1.7.0"

#   set {
#     name  = "linux.enabled"
#     value = true
#   }

#   set {
#     name  = "secrets-store-csi-driver.install"
#     value = false
#   }

#   depends_on = [helm_release.secrets_store_csi_driver]
# }


# # resource "kubernetes_secret" "tls" {
# #   for_each = {
# #     for cert in var.k8s_cluster.ssl_certificates : cert.certificate_name => cert
# #     if cert.key_vault_id != null
# #   }

# #   metadata {
# #     name      = each.value.certificate_name
# #     namespace = each.value.namespace
# #   }

# #   type = "kubernetes.io/tls"

# #   data = {
# #     "tls.crt" = data.external.decoded_certs[each.key].result.crt
# #     "tls.key" = data.external.decoded_certs[each.key].result.key
# #   }
# # }

