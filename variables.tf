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

variable "tenant_id" {
  description = "Tenant id for the resources"
  type        = string
  default     = null
}

# K8s clusters
variable "k8s_cluster" {
  description = "Single k8s cluster config (empty means no cluster)"
  type = object({
    acr_id         = optional(string)
    deploy_ingress = optional(bool)
    public_ip      = optional(bool)
    key_vault_access = optional(object({
      key_vault_id = string
      rbac_role    = optional(string)
    }))
    # ssl_certificates = optional(list(object({
    #   certificate_name = string
    #   key_vault_id     = string
    #   namespace        = string
    # })), [])
    default_node_pool = optional(object({
      node_count = number
      vm_size    = string
    }))
    # identity = optional(object({
    #   type = string
    # }))
  })
  default = {}
}

