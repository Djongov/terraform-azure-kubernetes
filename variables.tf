# Location for the resources, it will be used in naming and tagging of resources
variable "resource_group_name" {
  description = "Name for the resource group"
  type        = string
  default     = null
}
variable "location" {
  description = "Location for the resources"
  type        = string
  default     = "westeurope"
}

# Plays a role in naming and tagging of resources
variable "environment" {
  description = "Environment for the application"
  type        = string
}

# Subscription id for where to deploy the resources
variable "subscription_id" {
  description = "Subscription id"
  type        = string
}

variable "project_name" {
  description = "Project name for the resources"
  type        = string
}

variable "repo_name" {
  description = "name of the repository"
  type        = string
  default     = null
}

# Common tags that will be applied to all resources
variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "vnet_subnet_id" {
  description = "Vnet subnet id for the resources"
  type        = string
  default     = null
}

variable "acr_id" {
  description = "Azure Container Registry ID for the resources"
  type        = string
  default     = null
}

# K8s clusters
variable "k8s_cluster" {
  description = "AKS configuration including app deployments"
  type = object({
    network_plugin               = string           # "azure, kubenet, or none"
    network_policy               = string           # "calico, azure, or none"
    default_node_pool_node_count = optional(number) # default is 1
    default_node_pool_vm_size    = optional(string) # default is "Standard_B4ms"
    key_vault_id                 = string
    ingress                      = string # "nginx" or "agic" or "addon"
    tags                         = optional(map(string))
    namespaces = optional(map(object({
      apps = map(object({
        repository = string
        node = object({
          node_count           = number
          vm_size              = string
          min_count            = optional(number)
          max_count            = optional(number)
          auto_scaling_enabled = optional(bool)
        })
        tls = optional(object({
          certificate_name = optional(string)
          secret_name      = optional(string)
        }))
        deployment = object({
          container_port = number
          env            = optional(map(string))
          replicas       = optional(number)
        })
        service = object({
          type = string
          port = number
        })
        ingress = optional(object({
          host = string
          path = string
        }))
      }))
    })))
  })
}
