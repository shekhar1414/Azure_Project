output "vm_subnet_id" {
  description = "The ID of the VM subnet."
  value       = azurerm_subnet.vm_subnet.id
}

output "db_subnet_id" {
  description = "The ID of the DB subnet."
  value       = azurerm_subnet.db_subnet.id
}

output "monitoring_subnet_id" {
  description = "The ID of the monitoring subnet."
  value       = azurerm_subnet.monitoring_subnet.id
}
