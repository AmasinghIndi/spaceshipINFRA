# Create a resource group
resource "azurerm_resource_group" "indi" {
  name     = "rg-indi"
  location = "West Europe"
  tags = {
    owner = "inderjit.singh@redbull.com"
  }
}

resource "azurerm_virtual_network" "indi" {
  name                = "indi-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.indi.location
  resource_group_name = azurerm_resource_group.indi.name
}

resource "azurerm_subnet" "indi" {
  name                 = "indi-subnet"
  resource_group_name  = azurerm_resource_group.indi.name
  virtual_network_name = azurerm_virtual_network.indi.name
  address_prefixes     = ["10.0.1.0/24"]

}

resource "azurerm_network_interface" "indi" {
  name                = "indi-nic"
  location            = azurerm_resource_group.indi.location
  resource_group_name = azurerm_resource_group.indi.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.indi.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "indi" {
  name                = "indi-machine"
  resource_group_name = azurerm_resource_group.indi.name
  location            = azurerm_resource_group.indi.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password = "Test123"
  disable_password_authentication = "false"
  network_interface_ids = [
    azurerm_network_interface.indi.id,
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
#