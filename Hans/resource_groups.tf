# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "jlk_resource_group"
  location = "West Europe"

tags = {
    owner = "Johann.Lechner-Kari@redbull.com"
  }
}