



# Create a resource group
resource "azurerm_resource_group" "crew_members_via_tf" {
  name     = "crew_members_via_tf"
  location = "West Europe"
  tags = {
    owner = "kacper.kowalczyk@redbull.com"
  }
}

