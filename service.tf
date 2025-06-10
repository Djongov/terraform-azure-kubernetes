resource "kubernetes_service" "apps" {
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
    selector = {
      app = each.value.app_name
    }

    port {
      port        = each.value.service.port
      target_port = each.value.deployment.container_port
    }

    type = each.value.service.type
  }
}
