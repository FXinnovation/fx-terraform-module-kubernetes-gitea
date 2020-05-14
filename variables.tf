#####
# Global
#####

variable "enabled" {
  description = "Whether or not to enable this module."
  default     = true
}

variable "namespace" {
  description = "Name of the namespace in which to deploy the module."
  default     = "default"
}

variable "annotations" {
  description = "Map of annotations that will be applied on all resources."
  default     = {}
}

variable "labels" {
  description = "Map of labels that will be applied on all resources."
  default     = {}
}

#####
# Application
#####

variable "image" {
  description = "Image to use."
  default     = "fxinnovation/gitea"
}

variable "image_version" {
  description = "Version of the image to use."
  default     = "0.9.0"
}

variable "resources_requests_cpu" {
  description = "Amount of cpu time that the application requests."
  default     = "50m"
}

variable "resources_requests_memory" {
  description = "Amount of memory that the application requests."
  default     = "128Mi"
}

variable "resources_limits_cpu" {
  description = "Amount of cpu time that the application limits."
  default     = "2"
}

variable "resources_limits_memory" {
  description = "Amount of memory that the application limits."
  default     = "2048Mi"
}

variable "configuration" {
  description = "Content of gitea's configuration ini file."
  default     = ""
}

#####
# StatefulSet
#####

variable "stateful_set_name" {
  description = "Name of the statefulset to deploy."
  default     = "gitea"
}

variable "stateful_set_annotations" {
  description = "Map of annotations that will be applied on the statefulset."
  default     = {}
}

variable "stateful_set_labels" {
  description = "Map of labels that will be applied on the statefulset."
  default     = {}
}

variable "stateful_set_template_annotations" {
  description = "Map of annotations that will be applied on the statefulset template."
  default     = {}
}

variable "stateful_set_template_labels" {
  description = "Map of labels that will be applied on the statefulset template."
  default     = {}
}

variable "stateful_set_volume_claim_template_enabled" {
  description = "Whether or not to enable the volume claim template on the statefulset."
  default     = true
}

variable "stateful_set_volume_claim_template_annotations" {
  description = "Map of annotations that will be applied on the statefulset volume claim template."
  default     = {}
}

variable "stateful_set_volume_claim_template_labels" {
  description = "Map of labels that will be applied on the statefulset volume claim template."
  default     = {}
}

variable "stateful_set_volume_claim_template_name" {
  description = "Name of the statefulset's volume claim template."
  default     = "gitea"
}

variable "stateful_set_volume_claim_template_storage_class" {
  description = "Storage class to use for the stateful set volume claim template."
  default     = null
}

variable "stateful_set_volume_claim_template_requests_storage" {
  description = "Size of storage the stateful set volume claim template requests."
  default     = "300Gi"
}

variable "stateful_set_additionnal_volume_mounts" {
  description = "List of objects representing additionnal volume mounts. *Note: Must be done in accordance with `stateful_set_additionnal_volumes`.*"
  default     = []
  type = list(
    object({
      name       = string # Name of the volume to mount
      mount_path = string # Path to mount the volume to
      sub_path   = any    # Sub path to mount the item
    })
  )
}

variable "stateful_set_additionnal_volumes" {
  description = <<EOT
List of objects representing additionnal volumes. *Note: Must be done in accordance with `stateful_set_additionnal_volume_mounts`.*
Must follow the following pattern:
```
list(
  object({
    name       = string # [Required] Name to give that that volume
    config_map = list(  # [Optional] List of maximum one config map object that should be a volume.
      object({
        name         = string # [Required] Name of the config map to use as volume.
        default_mode = string # [Optional] mode bits to use on created files by default.
        items        = list(  # [Optional] List of items to project into the volume. (default is to project all items)
          object({
            key  = string # [Required] The key to project
            mode = string # [Optional] Mode bits to use on this file. If not specified, the volume defaultMode will be used.
            path = string # [Required] The relative path of the file to map the key to.
          })
        )
      })
    )
    secret = list( # [Optional] List of maximum one secret object that should be a volume.
      object({
        secret_name  = string # [Required] Name of the config map to use as volume.
        default_mode = string # [Optional] mode bits to use on created files by default.
        optional     = bool   # [Optional] Specify whether the Secret or it's keys must be defined.
        items        = list(  # [Optional] List of items to project into the volume. (default is to project all items)
          object({
            key  = string # [Required] The key to project
            mode = string # [Optional] Mode bits to use on this file. If not specified, the volume defaultMode will be used.
            path = string # [Required] The relative path of the file to map the key to.
          })
        )
      })
    )
  })
)
```
EOT
  type        = list(any)
  default     = []
}

#####
# Service
#####

variable "service_name" {
  description = "Name of the service."
  default     = "gitea"
}

variable "service_annotations" {
  description = "Map of annotations that will be applied on the service."
  default     = {}
}

variable "service_labels" {
  description = "Map of labels that will be applied on the service."
  default     = {}
}

#####
# Ingress
#####

variable "ingress_enabled" {
  description = "Whether or not to enable the ingress."
  default     = true
}

variable "ingress_name" {
  description = "Name of the ingress."
  default     = "gitea"
}

variable "ingress_annotations" {
  description = "Map of annotations that will be applied on the ingress."
  default     = {}
}

variable "ingress_labels" {
  description = "Map of labels that will be applied on the ingress."
  default     = {}
}

variable "ingress_host" {
  description = "Host on which the ingress wil be available (ex: nexus.example.com)."
  default     = "example.com"
}

variable "ingress_tls_enabled" {
  description = "Whether or not TLS should be enabled on the ingress."
  default     = true
}

variable "ingress_tls_secret_name" {
  description = "Name of the secret to use to put TLS on the ingress."
  default     = "gitea"
}

#####
# Service
#####

variable "config_map_name" {
  description = "Name of the config map."
  default     = "gitea"
}

variable "config_map_annotations" {
  description = "Map of annotations that will be applied on the config map."
  default     = {}
}

variable "config_map_labels" {
  description = "Map of labels that will be applied on the config map."
  default     = {}
}
