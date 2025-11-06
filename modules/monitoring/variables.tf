

variable "location" {
  description = "The Azure region where the resources will be created"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace."
  type        = string
}

variable "data_collection_rule_name" {
  description = "The name of the Data Collection Rule."
  type        = string
}

variable "action_group_name" {
  description = "The name of the monitor action group."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the monitor action group."
  type        = string
}

variable "action_group_short_name" {
  description = "The short name of the monitor action group."
  type        = string
}
