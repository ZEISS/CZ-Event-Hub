resource "azurerm_kubernetes_cluster" "aks" {
  name                = "eventhub"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  dns_prefix          = "mt-aks-europe-poc-sourcegraph-dns"
  node_resource_group = "MC_Event-Hub-PoC"
  azure_policy_enabled = true

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D8as_v5" //"Standard_D4ds_v5"
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

// aks /w Istio
# resource "azurerm_kubernetes_cluster" "aks_argocd" {
#   name                = "event-hub"
#   resource_group_name = data.azurerm_resource_group.resource_group.name
#   location            = data.azurerm_resource_group.resource_group.location
#   dns_prefix          = "mt-aks-europe-poc-sourcegraph-dns"
#   node_resource_group = "MC_EventHub-PoC"
#   azure_policy_enabled = true

#   default_node_pool {
#     name       = "agentpool"
#     vm_size    = "Standard_D8as_v5"
#     type = "VirtualMachineScaleSets"
#     auto_scaling_enabled = true
#     min_count = 1
#     max_count = 3
#   }

#   network_profile {
#     network_plugin = "azure"
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   storage_profile {
#     disk_driver_enabled = true
#   }

#   oms_agent {
#     log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
#   }

#   microsoft_defender {
#     log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
#   }

#   lifecycle {
#     ignore_changes = [
#       tags["ContactEmailAddress"],
#     ]
#   }
# }

# add the role to the identity the kubernetes cluster was assigned
# resource "azurerm_role_assignment" "kubweb_to_acr" {
#   scope                = azurerm_container_registry.acr.id
#   role_definition_name = "AcrPull"
#   principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
# }

## private cluster

# resource "helm_release" "sourcegraph" {
#   name = "sourcegraph"
#   chart = "sourcegraph"
#   repository = "https://helm.sourcegraph.com/release"
#   namespace = "sourcegraph"
#   create_namespace = true
#   values = [ 
#     templatefile("../setup/override.yaml", {})
#   ]
# }