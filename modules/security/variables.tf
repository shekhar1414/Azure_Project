variable "prefix" {}
variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}
