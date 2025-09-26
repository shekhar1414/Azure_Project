resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
}

module "networking" {
  source              = "./modules/networking"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

module "security" {
  source              = "./modules/security"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.networking.subnet_id
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
}

module "storage" {
  source              = "./modules/storage"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

module "database" {
  source              = "./modules/database"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

module "backup" {
  source              = "./modules/backup"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  vm_ids              = module.compute.vm_ids
}
