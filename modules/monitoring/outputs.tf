
output "action_group_id" {
  description = "The ID of the monitor action group."
  value       = azurerm_monitor_action_group.main.id
}
