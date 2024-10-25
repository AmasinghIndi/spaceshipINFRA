# Create a resource group
resource "azurerm_resource_group" "hans" {
  name     = "jlk_resource_group"
  location = "West Europe"

tags = {
    owner = "Johann.Lechner-Kari@redbull.com"
  }
}

resource "azurerm_virtual_network" "hans" {
  name                = "jlk_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "West Europe"
  resource_group_name = azurerm_resource_group.hans.name
}

resource "azurerm_subnet" "hans" {
  name                 = "jlk_subnet"
  resource_group_name  = azurerm_resource_group.hans.name
  virtual_network_name = azurerm_virtual_network.hans.name
  address_prefixes     = ["10.0.1.0/24"]

}

resource "azurerm_public_ip" "hans" {
  name                = "hans-pip"
  location            = azurerm_resource_group.hans.location
  resource_group_name = azurerm_resource_group.hans.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "hans" {
  name                = "windowsvm_jlk_nic"
  location            = "West Europe"
  resource_group_name = azurerm_resource_group.hans.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.hans.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.hans.id
  }
}
