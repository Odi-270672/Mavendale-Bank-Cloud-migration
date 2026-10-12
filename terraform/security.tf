resource "azurerm_network_security_group" "web" {
  name                = "nsg-mavendale-web-dev-uks"
  location            = azurerm_resource_group.mavendale_dev.location
  resource_group_name = azurerm_resource_group.mavendale_dev.name

  tags = {
    Project     = "Mavendale Bank"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_subnet_network_security_group_association" "web_nsg_association" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web.id
}

resource "azurerm_network_security_rule" "web_allow_https" {
  name                        = "Allow-HTTPS-Inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "10.10.1.0/24"
  resource_group_name         = azurerm_resource_group.mavendale_dev.name
  network_security_group_name = azurerm_network_security_group.web.name

}

resource "azurerm_network_security_rule" "web_deny_db" {
  name                        = "Deny-Web-to-DB"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = azurerm_subnet.web.address_prefixes[0]
  destination_address_prefix  = azurerm_subnet.db.address_prefixes[0]
  resource_group_name         = azurerm_resource_group.mavendale_dev.name
  network_security_group_name = azurerm_network_security_group.web.name

}


resource "azurerm_network_security_group" "app" {
  name                = "nsg-mavendale-app-dev-uks"
  location            = azurerm_resource_group.mavendale_dev.location
  resource_group_name = azurerm_resource_group.mavendale_dev.name

  tags = {
    Project     = "Mavendale Bank"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_subnet_network_security_group_association" "app_nsg_association" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

resource "azurerm_network_security_group" "db" {
  name                = "nsg-mavendale-db-dev-uks"
  location            = azurerm_resource_group.mavendale_dev.location
  resource_group_name = azurerm_resource_group.mavendale_dev.name

  tags = {
    Project     = "Mavendale Bank"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_subnet_network_security_group_association" "db_nsg_association" {
  subnet_id                 = azurerm_subnet.db.id
  network_security_group_id = azurerm_network_security_group.db.id
}

resource "azurerm_network_security_rule" "db-allow-app-sql" {
  name                        = "Allow-App-to-DB-SQL"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = azurerm_subnet.app.address_prefixes[0]
  destination_address_prefix  = azurerm_subnet.db.address_prefixes[0]
  resource_group_name         = azurerm_resource_group.mavendale_dev.name
  network_security_group_name = azurerm_network_security_group.db.name

}

resource "azurerm_network_security_rule" "db_deny_other_vnet" {
  name                        = "Deny-Other-VNet-To-DB"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = one(azurerm_virtual_network.mavendale_vnet.address_space)
  destination_address_prefix  = azurerm_subnet.db.address_prefixes[0]
  resource_group_name         = azurerm_resource_group.mavendale_dev.name
  network_security_group_name = azurerm_network_security_group.db.name

}

resource "azurerm_network_security_rule" "web_allow_app_tcp" {
  name                        = "Allow-Web-to-App-TCP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = azurerm_subnet.web.address_prefixes[0]
  destination_address_prefix  = azurerm_subnet.app.address_prefixes[0]
  resource_group_name         = azurerm_resource_group.mavendale_dev.name
  network_security_group_name = azurerm_network_security_group.app.name

}

resource "azurerm_network_security_rule" "app_deny_other_vnet" {
  name                        = "Deny-Other-VNet-To-App"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = one(azurerm_virtual_network.mavendale_vnet.address_space)
  destination_address_prefix  = azurerm_subnet.app.address_prefixes[0]
  resource_group_name         = azurerm_resource_group.mavendale_dev.name
  network_security_group_name = azurerm_network_security_group.app.name

}