# resource "azurerm_storage_account" "tfstate" {
#   name                     = "acc23377sa01"
#   resource_group_name      = local.rg_name
#   location                 = var.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }
# 
# resource "azurerm_storage_container" "tfstate" {
#   name                  = "tfstate"
#   storage_account_name  = azurerm_storage_account.tfstate.name
#   container_access_type = "private"
# }
# 
# output "tfstate_storage_account_name" {
#   value = azurerm_storage_account.tfstate.name
# }
# 
# output "tfstate_container_name" {
#   value = azurerm_storage_container.tfstate.name
# }
