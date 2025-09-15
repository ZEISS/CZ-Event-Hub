resource "azurerm_user_assigned_identity" "identity" {
  name = "mt-identity-europe-event-hub"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location = data.azurerm_resource_group.resource_group.location
  lifecycle {
    ignore_changes = [
      tags["ContactEmailAddress"],
    ]
  }
}

# resource "azurerm_role_assignment" "appgw_contributor" {
#   principal_id = azurerm_user_assigned_identity.identity.principal_id
#   scope = azurerm_application_gateway.appgw.id
#   role_definition_name = "Contributor"
# }

# resource "azurerm_role_assignment" "vnet_contributor" {
#   principal_id = azurerm_user_assigned_identity.identity.principal_id
#   scope = azurerm_virtual_network.vnet.id
#   role_definition_name = "Network Contributor"
# }