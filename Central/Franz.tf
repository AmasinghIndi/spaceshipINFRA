# Create a resource group
resource "azurerm_resource_group" "franz" {
  name     = "rg-FRMA"
  location = "West Europe"
  tags = {
    owner = "Franz.Martinek@redbull.com"
  }
}
 
resource "azurerm_virtual_network" "franz" {
  name                = "FRMA-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.franz.location
  resource_group_name = azurerm_resource_group.franz.name
}
 
resource "azurerm_subnet" "franz" {
  name                 = "FRMA-subnet"
  resource_group_name  = azurerm_resource_group.franz.name
  virtual_network_name = azurerm_virtual_network.franz.name
  address_prefixes     = ["10.0.1.0/24"]
 
}

resource "azurerm_network_interface" "franz" {
  name                = "FRMA-nic"
  location            = azurerm_resource_group.franz.location
  resource_group_name = azurerm_resource_group.franz.name
 
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.franz.id
    private_ip_address_allocation = "Dynamic"
  }
}
 
resource "azurerm_linux_virtual_machine" "franz" {
  name                = "FRMA-machine"
  resource_group_name = azurerm_resource_group.franz.name
  location            = azurerm_resource_group.franz.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password = "testFRMA15"
  disable_password_authentication = "false"
  network_interface_ids = [
    azurerm_network_interface.franz.id,
  ]
 
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
 
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}