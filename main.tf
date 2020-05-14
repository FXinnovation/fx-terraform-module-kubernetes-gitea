#####
# Locals
#####

locals {
  ssh_port  = 22
  http_port = 80
  labels = {
    "version"    = var.image_version
    "part-of"    = "shared-services"
    "managed-by" = "terraform"
    "name"       = "gitea"
  }
  annotations = {}
}

#####
# Randoms
#####

resource "random_string" "selector" {
  special = false
  upper   = false
  number  = false
  length  = 8
}

#####
# Statefulset
#####

resource "kubernetes_stateful_set" "this" {
  metadata {
    name      = var.stateful_set_name
    namespace = var.namespace
    annotations = merge(
      local.annotations,
      var.annotations,
      var.stateful_set_annotations
    )
    labels = merge(
      {
        instance  = var.stateful_set_name
        component = "application"
      },
      local.labels,
      var.labels,
      var.stateful_set_labels
    )
  }

  spec {
    replicas     = 1
    service_name = kubernetes_service.this.metadata.0.name

    update_strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        selector = "gitea-${random_string.selector.result}"
      }
    }

    template {
      metadata {
        annotations = merge(
          local.annotations,
          var.annotations,
          var.stateful_set_template_annotations
        )
        labels = merge(
          {
            instance  = var.stateful_set_name
            component = "application"
            selector  = "gitea-${random_string.selector.result}"
          },
          local.labels,
          var.labels,
          var.stateful_set_template_labels
        )
      }

      spec {
        dynamic "init_container" {
          for_each = var.stateful_set_volume_claim_template_enabled ? [1] : []

          content {
            name              = "init-chown-data"
            image             = "busybox:latest"
            image_pull_policy = "IfNotPresent"
            command           = ["chown", "-R", "1000:1000", "/data"]

            volume_mount {
              name       = var.stateful_set_volume_claim_template_name
              mount_path = "/data"
              sub_path   = ""
            }
          }
        }

        container {
          name              = "gitea"
          image             = "${var.image}:${var.image_version}"
          image_pull_policy = "IfNotPresent"

          resources {
            requests = {
              cpu    = var.resources_requests_cpu
              memory = var.resources_requests_memory
            }
            limits = {
              cpu    = var.resources_limits_cpu
              memory = var.resources_limits_memory
            }
          }

          port {
            container_port = 3000
            protocol       = "TCP"
            name           = "http"
          }

          port {
            container_port = 22
            protocol       = "TCP"
            name           = "ssh"
          }

          readiness_probe {
            http_get {
              path   = "/"
              port   = 3000
              scheme = "HTTP"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 10
            failure_threshold     = 10
            success_threshold     = 1
            period_seconds        = 10
          }

          liveness_probe {
            http_get {
              path   = "/"
              port   = 3000
              scheme = "HTTP"
            }

            initial_delay_seconds = 140
            timeout_seconds       = 5
            failure_threshold     = 5
            success_threshold     = 1
            period_seconds        = 10
          }

          dynamic "volume_mount" {
            for_each = var.stateful_set_volume_claim_template_enabled ? [1] : []

            content {
              name       = var.stateful_set_volume_claim_template_name
              mount_path = "/data"
              sub_path   = ""
            }
          }

          volume_mount {
            name       = "configuration"
            mount_path = "/data/gitea/conf"
          }

          dynamic "volume_mount" {
            for_each = var.stateful_set_additionnal_volume_mounts

            content {
              name       = volume_mount.value.name
              mount_path = volume_mount.value.mount_path
              sub_path   = lookup(volume.value, "sub_path", null)
            }
          }
        }

        volume {
          name = "configuration"
          config_map {
            name = kubernetes_config_map.this.metadata.0.name
          }
        }

        dynamic "volume" {
          for_each = var.stateful_set_additionnal_volumes

          content {
            name = value.name

            dynamic "config_map" {
              for_each = lookup(volume.value, "config_map", [])

              content {
                default_mode = lookup(config_map.value, "default_mode", null)
                name         = config_map.value.name
                dynamic "items" {
                  for_each = lookup(config_map.value, "items", [])

                  content {
                    key  = items.value.key
                    path = items.value.path
                    mode = lookup(items.value, "mode", null)
                  }
                }
              }
            }
            dynamic "secret" {
              for_each = lookup(volume.value, "secret", [])

              content {
                default_mode = lookup(secret.value, "default_mode", null)
                secret_name  = secret.value.name
                dynamic "items" {
                  for_each = lookup(secret.value, "items", [])

                  content {
                    key  = items.value.key
                    path = items.value.path
                    mode = lookup(items.value, "mode", null)
                  }
                }
              }
            }
          }
        }
      }
    }

    dynamic "volume_claim_template" {
      for_each = var.stateful_set_volume_claim_template_enabled ? [1] : []

      content {
        metadata {
          name      = var.stateful_set_volume_claim_template_name
          namespace = var.namespace
          annotations = merge(
            local.annotations,
            var.annotations,
            var.stateful_set_volume_claim_template_annotations
          )
          labels = merge(
            {
              instance  = var.stateful_set_volume_claim_template_name
              component = "storage"
            },
            local.labels,
            var.labels,
            var.stateful_set_volume_claim_template_labels
          )
        }

        spec {
          access_modes       = ["ReadWriteOnce"]
          storage_class_name = var.stateful_set_volume_claim_template_storage_class
          resources {
            requests = {
              storage = var.stateful_set_volume_claim_template_requests_storage
            }
          }
        }
      }
    }
  }
}

#####
# Service
#####

resource "kubernetes_service" "this" {
  metadata {
    name      = var.service_name
    namespace = var.namespace
    annotations = merge(
      local.annotations,
      var.annotations,
      var.service_annotations
    )
    labels = merge(
      {
        "instance"  = var.service_name
        "component" = "network"
      },
      local.labels,
      var.labels,
      var.service_labels
    )
  }

  spec {
    selector = {
      selector = "gitea-${random_string.selector.result}"
    }

    type = "ClusterIP"

    port {
      port        = local.http_port
      target_port = "http"
      protocol    = "TCP"
      name        = "http"
    }

    port {
      port        = local.ssh_port
      target_port = "ssh"
      protocol    = "TCP"
      name        = "ssh"
    }
  }
}

#####
# Ingress
#####

resource "kubernetes_ingress" "this" {
  count = var.ingress_enabled ? 1 : 0

  metadata {
    name      = var.ingress_name
    namespace = var.namespace
    annotations = merge(
      local.annotations,
      var.annotations,
      var.ingress_annotations
    )
    labels = merge(
      {
        instance  = var.ingress_name
        component = "network"
      },
      local.labels,
      var.labels,
      var.ingress_labels
    )
  }

  spec {
    backend {
      service_name = kubernetes_service.this.metadata.0.name
      service_port = "http"
    }

    rule {
      host = var.ingress_host
      http {
        path {
          backend {
            service_name = kubernetes_service.this.metadata.0.name
            service_port = "http"
          }
          path = "/"
        }
      }
    }

    dynamic "tls" {
      for_each = var.ingress_tls_enabled ? [1] : []

      content {
        secret_name = var.ingress_tls_secret_name
        hosts       = [var.ingress_host]
      }
    }
  }
}

#####
# Configmap
#####

resource "kubernetes_config_map" "this" {
  metadata {
    name      = var.config_map_name
    namespace = var.namespace
    annotations = merge(
      {
        instance  = var.config_map_name,
        component = "configuration"
      },
      local.annotations,
      var.annotations,
      var.config_map_annotations
    )
    labels = merge(
      local.labels,
      var.labels,
      var.config_map_labels
    )
  }

  data = {
    "app.ini" = var.configuration
  }
}
