

variable "vm_ids" {
  description = "The IDs of the VMs to be backed up."
  type        = list(string)
}

variable "prefix" {
  description = "The prefix for the resource names."
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
}