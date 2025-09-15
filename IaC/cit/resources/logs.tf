resource "azurerm_log_analytics_workspace" "law" {
  name                = var.law_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  sku                 = "PerGB2018"
  retention_in_days   = 90
  tags                = var.tags
  lifecycle {
    ignore_changes = [
      tags["ContactEmailAddress"],
    ]
  }
}
