output "sql_server_id" {
  description = "The ID of the MS SQL server."
  value       = azurerm_mssql_server.sql.id
}

output "cosmosdb_account_id" {
  description = "The ID of the Cosmos DB account."
  value       = azurerm_cosmosdb_account.cosmos.id
}

output "db_id" {
  description = "The ID of the SQL database."
  value       = azurerm_mssql_database.sqldb.id
}
