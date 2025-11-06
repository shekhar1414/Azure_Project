

resource "azurerm_log_analytics_workspace" "main" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_monitor_data_collection_rule" "main" {
  name                = var.data_collection_rule_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["log_analytics"]
  }

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.main.id
      name                  = "log_analytics"
    }
  }
}

resource "azurerm_monitor_action_group" "main" {
  name                = var.action_group_name
  resource_group_name = var.resource_group_name
  short_name          = var.action_group_short_name

  email_receiver {
    name          = "sendtodevops"
    email_address = "devops@example.com"
  }
}
