# Location for the resources, it will be used in naming and tagging of resources
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
  default = null
}

# Common tags that will be applied to all resources
variable "common_tags" {
  type    = map(string)
  default = {}
}

# K8s clusters
variable "k8s_clusters" {
  description = "Map of k8s clusters to create"
  type        = map(object({
    default_node_pool = object({
      node_count = number
      vm_size    = string
      vnet_subnet_id = string
    })
    identity = optional(object({
      type = string
    }))
  }))
  default = {}
}