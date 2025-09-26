variable "prefix" {}
variable "location" {}
variable "resource_group_name" {}
variable "vm_ids" {}
variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}
