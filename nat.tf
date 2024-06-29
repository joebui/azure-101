# Public IP address for NAT gateway
resource "azurerm_public_ip" "my_public_ip" {
  name                = "public-ip-nat"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# NAT Gateway
resource "azurerm_nat_gateway" "my_nat_gateway" {
  name                = "nat-gateway"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Associate NAT Gateway with Public IP
resource "azurerm_nat_gateway_public_ip_association" "example" {
  nat_gateway_id       = azurerm_nat_gateway.my_nat_gateway.id
  public_ip_address_id = azurerm_public_ip.my_public_ip.id
}

# Associate NAT Gateway with Subnets
resource "azurerm_subnet_nat_gateway_association" "one" {
  subnet_id      = azurerm_subnet.one.id
  nat_gateway_id = azurerm_nat_gateway.my_nat_gateway.id
}

resource "azurerm_subnet_nat_gateway_association" "two" {
  subnet_id      = azurerm_subnet.two.id
  nat_gateway_id = azurerm_nat_gateway.my_nat_gateway.id
}
