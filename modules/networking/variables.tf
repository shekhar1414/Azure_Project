variable "prefix" {}
variable "location" {}
variable "resource_group_name" {}
variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "sql_server_id" {
  description = "The ID of the MS SQL server for the private endpoint."
  type        = string
  default     = null
}

variable "cosmosdb_account_id" {
  description = "The ID of the Cosmos DB account for the private endpoint."
  type        = string
  default     = null
}