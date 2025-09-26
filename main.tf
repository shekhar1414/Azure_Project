resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
  tags     = local.common_tags
}

module "networking" {
  source              = "./modules/networking"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.common_tags
}

module "security" {
  source              = "./modules/security"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.networking.subnet_id
  tags                = local.common_tags
}

module "compute" {
  source              = "./modules/compute"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
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
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.common_tags
}

module "database" {
  source              = "./modules/database"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.common_tags
  subnet_id           = module.networking.subnet_id
}

module "backup" {
  source              = "./modules/backup"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  vm_ids              = module.compute.vm_ids
  tags                = local.common_tags
}
