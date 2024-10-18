



# Create a resource group
resource "azurerm_resource_group" "crew_members_via_tf" {
  name     = "crew_members_via_tf"
  location = "Poland Central"
  tags = {
    owner = "kacper.kowalczyk@redbull.com"
  }
}

resource "azurerm_virtual_network" "network-vnet" {
  name                = "network-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "Poland Central"
  resource_group_name = "crew_members_via_tf"
}

resource "azurerm_subnet" "network-vnet" {
  name                 = "network-subnet"
  resource_group_name  = "crew_members_via_tf"
  virtual_network_name = "network-vnet"
  address_prefixes     = ["10.0.1.0/24"]

  
    }
  
