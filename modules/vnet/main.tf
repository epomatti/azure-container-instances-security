resource "azurerm_virtual_network" "default" {
  name                = "vnet-${var.workload}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "containers" {
  name                 = "containers"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.0.0/24"]

  delegation {
    name = "Microsoft.ContainerInstance.containerGroups"

    service_delegation {
      name = "Microsoft.ContainerInstance/containerGroups"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
    }
  }
}

resource "azurerm_subnet" "app_gateway" {
  name                 = "appgateway"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.10.0/24"]
}

resource "azurerm_network_security_group" "default" {
  name                = "nsg-${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "containers" {
  subnet_id                 = azurerm_subnet.containers.id
  network_security_group_id = azurerm_network_security_group.default.id
}

resource "azurerm_subnet_network_security_group_association" "app_gateway" {
  subnet_id                 = azurerm_subnet.app_gateway.id
  network_security_group_id = azurerm_network_security_group.default.id
}
