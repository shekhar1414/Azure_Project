resource "azurerm_recovery_services_vault" "backupvault" {
  name                = "${var.prefix}-BKV01"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_backup_policy_vm" "vmpolicy" {
  name                = "${var.prefix}-VMPOLICY01"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.backupvault.name
  timezone            = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }
}

resource "azurerm_backup_protected_vm" "protect" {
  count                = length(var.vm_ids)
  resource_group_name  = var.resource_group_name
  recovery_vault_name  = azurerm_recovery_services_vault.backupvault.name
  source_vm_id         = element(var.vm_ids, count.index)
  backup_policy_id     = azurerm_backup_policy_vm.vmpolicy.id
}
