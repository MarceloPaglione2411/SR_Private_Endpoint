#Criação RG
resource "azurerm_resource_group" "mod_resource_group1" {
  name     = var.rs_name
  location = var.rs_location
  tags = {
    name = "Ambiente"
    environment = "Storage Account"
  }
}
