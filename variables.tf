variable "prefix" {
  description = "Prefix for all resources"
  default     = "ACC-23377-Azure-NPRD-AICAP"
}

variable "location" {
  description = "Azure region"
  default     = "Central India"
}

variable "admin_username" {
  default = "vmadmin"
}

variable "admin_password" {
  default = "VmAdmin!1234" # Must meet Azure password policy
}

variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}
