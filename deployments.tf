
resource "kubernetes_deployment" "apps" {
  for_each = {
    for app in local.apps_flat : "${app.namespace}-${app.app_name}" => app
  }

  metadata {
    name      = each.value.app_name
    namespace = each.value.namespace
    labels = {
      app = each.value.app_name
    }
  }

  spec {
    replicas = lookup(each.value.deployment, "replicas", 1)

    selector {
      match_labels = {
        app = each.value.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = each.value.app_name
        }
      }

      spec {
        # Add a toleration to allow this pod to be scheduled on the dedicated node pool.
        toleration {
          key      = "app"
          operator = "Equal"
          value    = each.value.app_name
          effect   = "NoSchedule"
        }
        # --------------------
        dynamic "volume" {
          for_each = each.value.tls != null ? [each.value.tls] : []
          content {
            name = "tls-secret"

            csi {
              driver    = "secrets-store.csi.k8s.io"
              read_only = true
              volume_attributes = {
                secretProviderClass = "${each.value.namespace}-${each.value.app_name}-spc"
              }
              # node_publish_secret_ref {
              #   name = "${each.value.namespace}-${each.value.app_name}-spc-node-publish-secret"
              # }
            }
          }
        }

        container {
          name  = each.value.app_name
          image = each.value.repository

          port {
            container_port = each.value.deployment.container_port
          }

          dynamic "env" {
            for_each = lookup(each.value.deployment, "env", {})

            content {
              name  = env.key
              value = env.value
            }
          }

          dynamic "volume_mount" {
            for_each = each.value.tls != null ? [each.value.tls] : []
            content {
              name       = "tls-secret"
              mount_path = "/mnt/secrets/tls"
              read_only  = true
            }
          }
        }
      }
    }
  }
}

