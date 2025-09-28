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
  description = "The admin password for the virtual machine. Should be configured in a variable group."
  sensitive   = true
}




