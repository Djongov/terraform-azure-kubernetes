resource "kubernetes_manifest" "tls_secret_provider_class" {
  for_each = local.flat_apps_tls

  manifest = {
    apiVersion = "secrets-store.csi.x-k8s.io/v1"
    kind       = "SecretProviderClass"
    metadata = {
      name      = "${each.value.namespace}-${each.value.app_name}-spc"
      namespace = each.value.namespace
    }
    spec = {
      provider = "azure"
      secretObjects = [{
        secretName = each.value.secret_name != null ? each.value.secret_name : "ingress-tls"
        type       = "kubernetes.io/tls"
        data = [
          {
            objectName = each.value.certificate_name
            key        = "tls.key"
          },
          {
            objectName = each.value.certificate_name
            key        = "tls.crt"
          }
        ]
      }]
      parameters = {
        usePodIdentity       = "false"
        useVMManagedIdentity = "true"
        keyvaultName         = data.azurerm_key_vault.default[0].name
        tenantId             = data.azurerm_client_config.current.tenant_id

        objects = <<EOT
array:
  - objectName: ${each.value.certificate_name}
  - objectType: certificate
EOT
      }
    }
  }

  depends_on = [azurerm_kubernetes_cluster.this]
}
