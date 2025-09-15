resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  dns_prefix          = "cz-event-hub"
  node_resource_group = "MC_${data.azurerm_resource_group.resource_group.name}"
  azure_policy_enabled = true

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D8as_v5"
    type = "VirtualMachineScaleSets"
    auto_scaling_enabled = true
    min_count = 1
    max_count = 3
  }

  network_profile {
    network_plugin = "azure"
  }

  identity {
    type = "SystemAssigned"
  }

  storage_profile {
    disk_driver_enabled = true
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  }

  microsoft_defender {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  }

  lifecycle {
    ignore_changes = [
      tags["ContactEmailAddress"],
    ]
  }
}