resource "azurerm_virtual_network" "example" {
  name                = "jlk_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "West Europe"
  resource_group_name = "jlk_resource_group"
}

resource "azurerm_subnet" "example" {
  name                 = "jlk_subnet"
  resource_group_name  = "jlk_resource_group"
  virtual_network_name = "jlk_vnet"
  address_prefixes     = ["10.0.1.0/24"]

}