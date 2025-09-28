resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-VNET01"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-SUBNET01"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.prefix}-PIP01"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_lb" "lb" {
  name                = "${var.prefix}-LB01"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags                = var.tags

  frontend_ip_configuration {
    name                 = "PublicFrontEnd"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_lb_nat_rule" "ssh_nat_rule" {
  count                  = 3
  name                   = "SSH-NAT-Rule-VM-${count.index + 1}"
  resource_group_name    = var.resource_group_name
  loadbalancer_id        = azurerm_lb.lb.id
  protocol               = "Tcp"
  frontend_port          = 50001 + count.index
  backend_port           = 22
  frontend_ip_configuration_name = "PublicFrontEnd"
}

resource "azurerm_lb_backend_address_pool" "bepool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndPool"
}

resource "azurerm_lb_probe" "http_probe" {
  name                = "http-probe"
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Tcp"
  port                = 80
}

resource "azurerm_lb_probe" "https_probe" {
  name                = "https-probe"
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Tcp"
  port                = 443
}

resource "azurerm_lb_probe" "http8080_probe" {
  name                = "http8080-probe"
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Tcp"
  port                = 8080
}

resource "azurerm_lb_probe" "https8443_probe" {
  name                = "https8443-probe"
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Tcp"
  port                = 8443
}

# --- Private Endpoint for Azure SQL ---
resource "azurerm_private_dns_zone" "sql" {
  count               = var.sql_server_id != null ? 1 : 0
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql" {
  count                 = var.sql_server_id != null ? 1 : 0
  name                  = "${var.prefix}-sql-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sql[0].name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_endpoint" "sql" {
  count               = var.sql_server_id != null ? 1 : 0
  name                = "${var.prefix}-sql-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.subnet.id
  tags                = var.tags

  private_service_connection {
    name                           = "${var.prefix}-sql-psc"
    private_connection_resource_id = var.sql_server_id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql[0].id]
  }
}

# --- Private Endpoint for Cosmos DB ---
resource "azurerm_private_dns_zone" "cosmos" {
  count               = var.cosmosdb_account_id != null ? 1 : 0
  name                = "privatelink.documents.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos" {
  count                 = var.cosmosdb_account_id != null ? 1 : 0
  name                  = "${var.prefix}-cosmos-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos[0].name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_endpoint" "cosmos" {
  count               = var.cosmosdb_account_id != null ? 1 : 0
  name                = "${var.prefix}-cosmos-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.subnet.id
  tags                = var.tags

  private_service_connection {
    name                           = "${var.prefix}-cosmos-psc"
    private_connection_resource_id = var.cosmosdb_account_id
    is_manual_connection           = false
    subresource_names              = ["Sql"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.cosmos[0].id]
  }
}

output "subnet_id" {
  value = azurerm_subnet.subnet.id
}



output "lb_nat_rule_ids" {
  value = azurerm_lb_nat_rule.ssh_nat_rule.*.id
}

output "lb_backend_id" {
  value = azurerm_lb_backend_address_pool.bepool.id
}

output "lb_public_ip" {
  value = azurerm_public_ip.pip.ip_address
}