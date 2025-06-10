# resource "kubernetes_manifest" "app_ingress" {
#   for_each = local.flat_apps_ingress

#   manifest = {
#     apiVersion = "networking.k8s.io/v1"
#     kind       = "Ingress"
#     metadata = {
#       name      = "${each.key}-ingress"
#       namespace = each.value.namespace
#     }
#     spec = merge(
#       {
#         ingressClassName = "nginx"
#         rules = [{
#           host = each.value.host
#           http = {
#             paths = [{
#               path     = each.value.path
#               pathType = "Prefix"
#               backend = {
#                 service = {
#                   name = each.value.service_name
#                   port = {
#                     number = tonumber(each.value.service_port)
#                   }
#                 }
#               }
#             }]
#           }
#         }]
#       },
#       each.value.tls_secret != null ? {
#         tls = [{
#           secretName = each.value.tls_secret
#         }]
#       } : {}
#     )
#   }

# }

# resource "helm_release" "nginx_ingress" {
#   count = var.k8s_cluster.ingress == "nginx" ? 1 : 0

#   name       = "nginx-ingress"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   version    = "4.7.0"

#   namespace        = "ingress-nginx"
#   create_namespace = true

#   values = [
#     yamlencode({
#       controller = {
#         publishService = {
#           enabled = true
#         }
#         service = {
#           type = "LoadBalancer"
#         }
#         config = {
#           "proxy-buffer-size"       = "16k"
#           "proxy-buffers-number"    = "8"
#           "proxy-busy-buffers-size" = "16k"
#         }
#       }
#     })
#   ]
# }

# resource "kubernetes_manifest" "tls_secret_provider" {
#   for_each = local.flat_apps_tls

#   manifest = {
#     apiVersion = "secrets-store.csi.x-k8s.io/v1"
#     kind       = "SecretProviderClass"
#     metadata = {
#       name      = "${each.key}-spc"
#       namespace = each.value.namespace
#     }
#     spec = {
#       provider = "azure"
#       parameters = {
#         usePodIdentity = "false"
#         keyvaultName   = data.azurerm_key_vault.default[0].name
#         tenantId       = data.azurerm_client_config.current.tenant_id
#         objects = jsonencode([
#           {
#             objectName = each.value.certificate_name
#             objectType = "secret"
#           }
#         ])
#       }
#       secretObjects = [
#         {
#           secretName = each.value.secret_name != null ? each.value.secret_name : "${each.key}-tls"
#           type       = "kubernetes.io/tls"
#           data = [
#             {
#               objectName = each.value.certificate_name
#               key        = "tls.key"
#             },
#             {
#               objectName = each.value.certificate_name
#               key        = "tls.crt"
#             }
#           ]
#         }
#       ]
#     }
#   }
# }

