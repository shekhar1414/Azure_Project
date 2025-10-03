variable "prefix" {}
variable "location" {}
variable "resource_group_name" {}
variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}
variable "subnet_id" {
  description = "The ID of the subnet to allow access from."
  type        = string
}
