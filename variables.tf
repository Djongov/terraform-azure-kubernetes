# Name of the resource group, it will be used for placing resources in this group, it might come from the module output or be a string
variable "resource_group_name" {
  description = "Name for the resource group"
  type        = string
  default     = null
}

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

# Common tags that will be applied to all resources
variable "common_tags" {
  type    = map(string)
  default = {}
}

# insert your module specific variables here