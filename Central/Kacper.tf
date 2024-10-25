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
  resource_group_name = azurerm_resource_group.crew_members_via_tf.name
}

resource "azurerm_subnet" "network-vnet" {
  name                 = "network-subnet"
  resource_group_name  = azurerm_resource_group.crew_members_via_tf.name
  virtual_network_name = azurerm_virtual_network.network-vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  
    }
  

resource "azurerm_network_interface" "virtual_network" {
  name                = "virtual_network"
  location            = "Poland Central"
  resource_group_name = azurerm_resource_group.crew_members_via_tf.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.network-vnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "kacper-machine" {
  name                = "kacper-machine"
  resource_group_name = azurerm_resource_group.crew_members_via_tf.name
  location            = "Poland Central"
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password = "Kacper123$"

  disable_password_authentication = "false"

  network_interface_ids = [
    azurerm_network_interface.virtual_network.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}