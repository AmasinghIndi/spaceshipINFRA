# Create a resource group
resource "azurerm_resource_group" "hans-rg" {
  name     = "hans-rg"
  location = "westeurope"
  tags = {
    owner = "Franz.Martinek@redbull.com"
  }
}

module "hans-vm" {
  source                        = "./modules/vm"
  nic_name                      = "hans-nic"
  location                      = azurerm_resource_group.hans-rg.location
  resource_group_name           = azurerm_resource_group.hans-rg.name
  //subnet_id                   = azurerm_subnet.hans-subnet.id
  # when using vnet module:
  subnet_id                     = module.hans-vnet.subnet_id
  vm_name                       = "hansVM"
  vm_size                       = "Standard_DS1_v2"
  os_disk_name                  = "example-os-disk"
  image_publisher               = "Canonical"
  image_offer                   = "UbuntuServer"
  image_sku                     = "18.04-LTS"
  image_version                 = "latest"
  computer_name                 = "hostname"
  admin_username                = "adminuser"
  admin_password                = "Password1234!"
  disable_password_authentication = false
}

module "hans-vnet" {
  source              = "./modules/vnet"
  vnet_name           = "hans-vnet"
  address_space       = ["11.0.0.0/16"]
  location            = azurerm_resource_group.hans-rg.location
  resource_group_name = azurerm_resource_group.hans-rg.name
  subnet_name         = "hans-subnet"
  subnet_prefixes     = ["11.0.1.0/24"]
}