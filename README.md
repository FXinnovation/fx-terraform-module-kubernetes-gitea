# terraform-module-multi-template

Terraform module to deploy gitea on kubernetes.

**Important Note**
For SSH connections to work, you will have to configure you ingress controller (if it's capable of SSH forwarding) to forward all incoming traffic on a port of your selection and have it forwarded towards the service on the ssh port. You can use the service output to construct proper configuration for you ingress controller.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| kubernetes | >= 1.10.0 |
| random | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| kubernetes | >= 1.10.0 |
| random | >= 2.0.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [kubernetes_config_map](https://registry.terraform.io/providers/hashicorp/kubernetes/1.10.0/docs/resources/config_map) |
| [kubernetes_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/1.10.0/docs/resources/ingress) |
| [kubernetes_service](https://registry.terraform.io/providers/hashicorp/kubernetes/1.10.0/docs/resources/service) |
| [kubernetes_stateful_set](https://registry.terraform.io/providers/hashicorp/kubernetes/1.10.0/docs/resources/stateful_set) |
| [random_string](https://registry.terraform.io/providers/hashicorp/random/2.0.0/docs/resources/string) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| annotations | Map of annotations that will be applied on all resources. | `map` | `{}` | no |
| config\_map\_annotations | Map of annotations that will be applied on the config map. | `map` | `{}` | no |
| config\_map\_labels | Map of labels that will be applied on the config map. | `map` | `{}` | no |
| config\_map\_name | Name of the config map. | `string` | `"gitea"` | no |
| configuration | Content of gitea's configuration ini file. | `string` | `""` | no |
| enabled | Whether or not to enable this module. | `bool` | `true` | no |
| image | Image to use. | `string` | `"fxinnovation/gitea"` | no |
| image\_version | Version of the image to use. | `string` | `"0.9.0"` | no |
| ingress\_annotations | Map of annotations that will be applied on the ingress. | `map` | `{}` | no |
| ingress\_enabled | Whether or not to enable the ingress. | `bool` | `true` | no |
| ingress\_host | Host on which the ingress wil be available (ex: nexus.example.com). | `string` | `"example.com"` | no |
| ingress\_labels | Map of labels that will be applied on the ingress. | `map` | `{}` | no |
| ingress\_name | Name of the ingress. | `string` | `"gitea"` | no |
| ingress\_tls\_enabled | Whether or not TLS should be enabled on the ingress. | `bool` | `true` | no |
| ingress\_tls\_secret\_name | Name of the secret to use to put TLS on the ingress. | `string` | `"gitea"` | no |
| labels | Map of labels that will be applied on all resources. | `map` | `{}` | no |
| namespace | Name of the namespace in which to deploy the module. | `string` | `"default"` | no |
| resources\_limits\_cpu | Amount of cpu time that the application limits. | `string` | `"2"` | no |
| resources\_limits\_memory | Amount of memory that the application limits. | `string` | `"2048Mi"` | no |
| resources\_requests\_cpu | Amount of cpu time that the application requests. | `string` | `"50m"` | no |
| resources\_requests\_memory | Amount of memory that the application requests. | `string` | `"128Mi"` | no |
| service\_annotations | Map of annotations that will be applied on the service. | `map` | `{}` | no |
| service\_labels | Map of labels that will be applied on the service. | `map` | `{}` | no |
| service\_name | Name of the service. | `string` | `"gitea"` | no |
| stateful\_set\_additionnal\_volume\_mounts | List of objects representing additionnal volume mounts. *Note: Must be done in accordance with `stateful_set_additionnal_volumes`.* | <pre>list(<br>    object({<br>      name       = string # Name of the volume to mount<br>      mount_path = string # Path to mount the volume to<br>      sub_path   = any    # Sub path to mount the item<br>    })<br>  )</pre> | `[]` | no |
| stateful\_set\_additionnal\_volumes | List of objects representing additionnal volumes. *Note: Must be done in accordance with `stateful_set_additionnal_volume_mounts`.*<br>Must follow the following pattern:<pre>list(<br>  object({<br>    name       = string # [Required] Name to give that that volume<br>    config_map = list(  # [Optional] List of maximum one config map object that should be a volume.<br>      object({<br>        name         = string # [Required] Name of the config map to use as volume.<br>        default_mode = string # [Optional] mode bits to use on created files by default.<br>        items        = list(  # [Optional] List of items to project into the volume. (default is to project all items)<br>          object({<br>            key  = string # [Required] The key to project<br>            mode = string # [Optional] Mode bits to use on this file. If not specified, the volume defaultMode will be used.<br>            path = string # [Required] The relative path of the file to map the key to.<br>          })<br>        )<br>      })<br>    )<br>    secret = list( # [Optional] List of maximum one secret object that should be a volume.<br>      object({<br>        secret_name  = string # [Required] Name of the config map to use as volume.<br>        default_mode = string # [Optional] mode bits to use on created files by default.<br>        optional     = bool   # [Optional] Specify whether the Secret or it's keys must be defined.<br>        items        = list(  # [Optional] List of items to project into the volume. (default is to project all items)<br>          object({<br>            key  = string # [Required] The key to project<br>            mode = string # [Optional] Mode bits to use on this file. If not specified, the volume defaultMode will be used.<br>            path = string # [Required] The relative path of the file to map the key to.<br>          })<br>        )<br>      })<br>    )<br>  })<br>)</pre> | `list(any)` | `[]` | no |
| stateful\_set\_annotations | Map of annotations that will be applied on the statefulset. | `map` | `{}` | no |
| stateful\_set\_labels | Map of labels that will be applied on the statefulset. | `map` | `{}` | no |
| stateful\_set\_name | Name of the statefulset to deploy. | `string` | `"gitea"` | no |
| stateful\_set\_template\_annotations | Map of annotations that will be applied on the statefulset template. | `map` | `{}` | no |
| stateful\_set\_template\_labels | Map of labels that will be applied on the statefulset template. | `map` | `{}` | no |
| stateful\_set\_volume\_claim\_template\_annotations | Map of annotations that will be applied on the statefulset volume claim template. | `map` | `{}` | no |
| stateful\_set\_volume\_claim\_template\_enabled | Whether or not to enable the volume claim template on the statefulset. | `bool` | `true` | no |
| stateful\_set\_volume\_claim\_template\_labels | Map of labels that will be applied on the statefulset volume claim template. | `map` | `{}` | no |
| stateful\_set\_volume\_claim\_template\_name | Name of the statefulset's volume claim template. | `string` | `"gitea"` | no |
| stateful\_set\_volume\_claim\_template\_requests\_storage | Size of storage the stateful set volume claim template requests. | `string` | `"300Gi"` | no |
| stateful\_set\_volume\_claim\_template\_storage\_class | Storage class to use for the stateful set volume claim template. | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| config\_map | n/a |
| ingress | n/a |
| namespace\_name | n/a |
| service | n/a |
| statefulset | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Versioning
This repository follows [Semantic Versioning 2.0.0](https://semver.org/)

## Git Hooks
This repository uses [pre-commit](https://pre-commit.com/) hooks.

### Usage

```
pre-commit install
pre-commit install -t commit-msg
```

## Commit Messages

This repository follows the [afcmf](https://scm.dazzlingwrench.fxinnovation.com/fxinnovation-public/pre-commit-afcmf) standard for it's commit messages.

## Changelog

The changelog file is generated using the `git-extras` package using the following command:
```
git changelog -a -t <target-version> -p
```
