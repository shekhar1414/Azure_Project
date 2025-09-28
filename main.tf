data "azurerm_resource_group" "rg" {
  name = local.rg_name
}

module "networking" {
  source              = "./modules/networking"
  prefix              = var.prefix
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = local.common_tags
}

module "security" {
  source              = "./modules/security"
  prefix              = var.prefix
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.networking.subnet_id
  tags                = local.common_tags
}

module "compute" {
  source              = "./modules/compute"
  prefix              = var.prefix
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.networking.subnet_id
  lb_backend_id       = module.networking.lb_backend_id
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  tags                = local.common_tags
  lb_nat_rule_ids     = module.networking.lb_nat_rule_ids
}

module "storage" {
  source              = "./modules/storage"
  prefix              = var.prefix
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = local.common_tags
}

module "database" {
  source              = "./modules/database"
  prefix              = var.prefix
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = local.common_tags
  subnet_id           = module.networking.subnet_id
}

module "backup" {
  source              = "./modules/backup"
  prefix              = var.prefix
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  vm_ids              = module.compute.vm_ids
  tags                = local.common_tags
}

# --- Private Endpoint for Azure SQL ---
resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = local.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql" {
  name                  = "${var.prefix}-sql-dns-link"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  virtual_network_id    = module.networking.vnet_id # Assuming vnet_id is an output from networking module
}

resource "azurerm_private_endpoint" "sql" {
  name                = "${var.prefix}-sql-pe"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.networking.subnet_id
  tags                = local.common_tags

  private_service_connection {
    name                           = "${var.prefix}-sql-psc"
    private_connection_resource_id = module.database.sql_server_id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql.id]
  }
}

# --- Private Endpoint for Cosmos DB ---
resource "azurerm_private_dns_zone" "cosmos" {
  name                = "privatelink.documents.azure.com"
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = local.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos" {
  name                  = "${var.prefix}-cosmos-dns-link"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos.name
  virtual_network_id    = module.networking.vnet_id # Assuming vnet_id is an output from networking module
}

resource "azurerm_private_endpoint" "cosmos" {
  name                = "${var.prefix}-cosmos-pe"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.networking.subnet_id
  tags                = local.common_tags

  private_service_connection {
    name                           = "${var.prefix}-cosmos-psc"
    private_connection_resource_id = module.database.cosmosdb_account_id
    is_manual_connection           = false
    subresource_names              = ["Sql"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.cosmos.id]
  }
}
