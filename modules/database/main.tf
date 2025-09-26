resource "azurerm_mssql_server" "sql" {
  name                         = lower("${var.prefix}-SQL01")
  resource_group_name          = var.resource_group_name
  location                    = var.location
  version                     = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "Password1234!"
  tags                         = var.tags
}

resource "azurerm_mssql_virtual_network_rule" "sql_vnet_rule" {
  name      = "${var.prefix}-sql-vnet-rule"
  server_id = azurerm_mssql_server.sql.id
  subnet_id = var.subnet_id
}

resource "azurerm_cosmosdb_account" "cosmos" {
  name                = lower("${var.prefix}-cosmos01")
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  tags                = var.tags

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }
}
