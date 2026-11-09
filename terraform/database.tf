# Creates an Azure SQL Logical Server in UK West.
# WHY: Provides the logical host for our Mavendale SQL Database.
# The server manages database connections and authentication.
# It is NOT a physical server or Azure VM.

resource "azurerm_mssql_server" "mavendale_sql_server" {
  name                         = "sql-mavendale-dev-ukw"
  location                     = "ukwest"
  resource_group_name          = azurerm_resource_group.mavendale_dev.name
  version                      = "12.0"
  administrator_login          = "mavendaleadmin"
  administrator_login_password = var.sql_admin_password
}


# Creates the Mavendale Bank SQL Database within the logical server.
# WHY: Stores the application's relational data.
# server_id links the database to the SQL Logical Server above.
# Basic is the selected low-cost database service tier.

resource "azurerm_mssql_database" "mavendale_database" {
  name      = "sqldb-mavendale-dev-ukw"
  server_id = azurerm_mssql_server.mavendale_sql_server.id
  sku_name  = "Basic"
}


# Creates a Private Endpoint for the Azure SQL Logical Server.
# WHY: Allows resources in our UK South VNet to connect to Azure SQL
# through a private IP address instead of its public endpoint.
#
# The Private Endpoint is placed in our DB subnet in UK South,
# even though the Azure SQL service itself is hosted in UK West.

resource "azurerm_private_endpoint" "mavendale_sql_pe" {
  name                = "pe-mavendale-sql-dev-uks"
  location            = azurerm_resource_group.mavendale_dev.location
  resource_group_name = azurerm_resource_group.mavendale_dev.name
  subnet_id           = azurerm_subnet.db.id

  # Establishes the Private Link connection to our SQL Logical Server.
  # WHY: Identifies the Azure SQL resource that the Private Endpoint
  # should privately connect to.
  #
  # "sqlServer" specifies the Azure SQL Private Link subresource.
  # false means Azure requests automatic connection approval.

  private_service_connection {
    name                           = "psc-mavendale-sql-dev"
    private_connection_resource_id = azurerm_mssql_server.mavendale_sql_server.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  # Associates the Private Endpoint with our Private DNS Zone.
  # WHY: Azure can automatically create/manage the DNS A record
  # mapping the SQL Server's private hostname to its Private Endpoint IP.

  private_dns_zone_group {
    name                 = "sql-private-dns-zone-group"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.mavendale_sql_dns.id
    ]
  }
}


# Creates the Azure Private DNS Zone for Azure SQL Private Link.
# WHY: Holds the private DNS A record that maps our SQL Server's
# private hostname to the Private Endpoint's private IPv4 address.
#
# Example (illustrative):
# sql-mavendale-dev-ukw.privatelink.database.windows.net
#     -> 10.10.3.5

resource "azurerm_private_dns_zone" "mavendale_sql_dns" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.mavendale_dev.name
}


# Links our UK South VNet to the Azure SQL Private DNS Zone.
# WHY: Allows VMs and other resources using Azure-provided DNS
# within the VNet to resolve the SQL hostname to its private IP.
#
# Without this VNet link, the Private Endpoint's DNS record may
# exist, but our App VM would not automatically resolve it.
#
# registration_enabled = false prevents automatic registration
# of VM hostname records in this Private DNS Zone.

resource "azurerm_private_dns_zone_virtual_network_link" "mavendale_sql_dns_link" {
  name                  = "dnslink-mavendale-sql-dev-uks"
  resource_group_name   = azurerm_resource_group.mavendale_dev.name
  private_dns_zone_name = azurerm_private_dns_zone.mavendale_sql_dns.name
  virtual_network_id    = azurerm_virtual_network.mavendale_vnet.id
  registration_enabled  = false
}