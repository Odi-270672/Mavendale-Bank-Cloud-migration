resource "azurerm_route_table" "route_table" {
  name                = "rt-mavendale-app-dev-uks"
  resource_group_name = azurerm_resource_group.mavendale_dev.name
  location            = azurerm_resource_group.mavendale_dev.location
}

resource "azurerm_route" "route_to_firewall" {
  name                   = "route-to-hub-firewall"
  resource_group_name    = azurerm_resource_group.mavendale_dev.name
  route_table_name       = azurerm_route_table.route_table.name
  address_prefix         = "10.20.0.0/16"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.20.0.4"

}

resource "azurerm_subnet_route_table_association" "subnet_route_table_association" {
  subnet_id      = azurerm_subnet.app.id
  route_table_id = azurerm_route_table.route_table.id
}