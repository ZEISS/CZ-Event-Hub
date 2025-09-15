# resource "azurerm_container_registry" "acr" {
#   name                = "eventhubpoc"
#   resource_group_name = data.azurerm_resource_group.resource_group.name
#   location            = data.azurerm_resource_group.resource_group.location
#   sku = "Premium"
# }