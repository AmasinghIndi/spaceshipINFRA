# Create a resource group
resource "azurerm_resource_group" "indi-rg" {
  name     = "indi-rg"
  location = "West Europe"
  tags = {
    owner = "Franz.Martinek@redbull.com"
  }
}

module "indi-vm" {
  source                        = "./modules/vm"
  nic_name                      = "indi-nic"
  location                      = azurerm_resource_group.indi-rg.location
  resource_group_name           = azurerm_resource_group.indi-rg.name
  //subnet_id                   = azurerm_subnet.indi-subnet.id
  # when using vnet module:
  subnet_id                     = module.indi-vnet.subnet_id
  vm_name                       = "indiVM"
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

module "indi-vnet" {
  source              = "./modules/vnet"
  vnet_name           = "indi-vnet"
  address_space       = ["11.0.0.0/16"]
  location            = azurerm_resource_group.indi-rg.location
  resource_group_name = azurerm_resource_group.indi-rg.name
  subnet_name         = "indi-subnet"
  subnet_prefixes     = ["11.0.1.0/24"]
}