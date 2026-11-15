resource "azurerm_virtual_network_peering" "mavendale_spoke_to_hub" {
  name                         = "peering-mavendale-spoke-to-hub"
  resource_group_name          = azurerm_resource_group.mavendale_dev.name
  virtual_network_name         = azurerm_virtual_network.mavendale_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.mavendale_hub_vnet.id
  allow_virtual_network_access = true

}


resource "azurerm_virtual_network_peering" "mavendale_hub_to_spoke" {
  name                         = "peering-mavendale-hub-to-spoke"
  resource_group_name          = azurerm_resource_group.mavendale_dev.name
  virtual_network_name         = azurerm_virtual_network.mavendale_hub_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.mavendale_vnet.id
  allow_virtual_network_access = true

}
