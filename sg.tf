resource "azurerm_network_security_group" "lb" {
  name                = "public-lb"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "web"
    priority                   = 1008
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = local.http_port
    destination_address_prefix = azurerm_subnet.one.address_prefixes[0]
  }
}

resource "azurerm_subnet_network_security_group_association" "lb" {
  subnet_id                 = azurerm_subnet.one.id
  network_security_group_id = azurerm_network_security_group.lb.id
}
