# Create a resource group
resource "azurerm_resource_group" "kacper-rg" {
  name     = "kacper-rg"
  location = "West Europe"
  tags = {
    owner = "Franz.Martinek@redbull.com"
  }
}

module "kacper-vm" {
  source                        = "./modules/vm"
  nic_name                      = "kacper-nic"
  location                      = azurerm_resource_group.kacper-rg.location
  resource_group_name           = azurerm_resource_group.kacper-rg.name
  //subnet_id                   = azurerm_subnet.kacper-subnet.id
  # when using vnet module:
  subnet_id                     = module.kacper-vnet.subnet_id
  vm_name                       = "kacperVM"
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

module "kacper-vnet" {
  source              = "./modules/vnet"
  vnet_name           = "kacper-vnet"
  address_space       = ["11.0.0.0/16"]
  location            = azurerm_resource_group.kacper-rg.location
  resource_group_name = azurerm_resource_group.kacper-rg.name
  subnet_name         = "kacper-subnet"
  subnet_prefixes     = ["11.0.1.0/24"]
}