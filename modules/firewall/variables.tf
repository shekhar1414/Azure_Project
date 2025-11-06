
variable "prefix" {
  description = "The prefix for the resource names"
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}


variable "subnet_id" {
  description = "The ID of the subnet where the firewall will be deployed"
  type        = string
}

variable "vnet_id" {
  description = "The ID of the virtual network where the firewall will be deployed"
  type        = string
}

