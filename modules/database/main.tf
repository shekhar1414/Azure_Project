resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_mssql_server" "sql" {
  name                         = lower("${var.prefix}-SQL01-${random_string.suffix.result}")
  resource_group_name          = var.resource_group_name
  location                    = var.location
  version                     = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "Password1234!"
  tags                         = var.tags
}

resource "azurerm_mssql_database" "sqldb" {
  name           = "${var.prefix}-sqldb"
  server_id      = azurerm_mssql_server.sql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 1
  sku_name       = "S0"
  zone_redundant = false
  tags           = var.tags
}

resource "azurerm_mssql_virtual_network_rule" "sql_vnet_rule" {
  name      = "${var.prefix}-sql-vnet-rule"
  server_id = azurerm_mssql_server.sql.id
  subnet_id = var.subnet_id
}

resource "azurerm_cosmosdb_account" "cosmos" {
  name                = lower("${var.prefix}-cosmos01-${random_string.suffix.result}")
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

  backup {
    type                = "Periodic"
    interval_in_minutes = 1440
    retention_in_hours  = 24
  }
}
