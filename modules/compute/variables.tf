variable "prefix" {}
variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "lb_backend_id" {}
variable "admin_username" {}
variable "admin_password" {}
variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}
variable "lb_nat_rule_ids" {
  description = "A list of load balancer NAT rule IDs."
  type        = list(string)
}

variable "vm_count" {
  description = "The number of virtual machines to create."
  type        = number
}
