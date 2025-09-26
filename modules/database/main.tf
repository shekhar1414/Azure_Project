resource "azurerm_mssql_server" "sql" {
  name                         = lower("${var.prefix}-SQL01")
  resource_group_name          = var.resource_group_name
  location                    = var.location
  version                     = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "Password1234!"
}

resource "azurerm_cosmosdb_account" "cosmos" {
  name                = lower("${var.prefix}-cosmos01")
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }
}
