##Criação Storage Account + Share_File
#################################################################
resource "azurerm_storage_account" "MOD_STORAGE_ACCOUNT" {
  name                     = "sr123marcelopaglione"
  resource_group_name      = var.rs_name
  location                 = var.rs_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"

  tags = {
    environment = "STORAGE_ACCOUNT"
  }
}
resource "azurerm_storage_share" "MOD_PASTA_SHARE" {
  name                 = "fsmarcelo"
  #storage_account_name = azurerm_storage_account.MOD_STORAGE_ACCOUNT.id
  storage_account_id = azurerm_storage_account.MOD_STORAGE_ACCOUNT.id
  #container_access_type = "private"
  quota                = 50
}

resource "azurerm_storage_share_directory" "MOD_SHARE_DIRECTORY" {
  name             = "FINANCEIRO"
  storage_share_id = azurerm_storage_share.MOD_PASTA_SHARE.id
}

data "azurerm_storage_account_network_rules" "MOD-NETWORK_RULES" {
  storage_account_id = azurerm_storage_account.MOD_STORAGE_ACCOUNT.id

  default_action             = "Allow"
  ip_rules                   = ["127.0.0.1"]
  virtual_network_subnet_ids = [azurerm_subnet.MOD_NSG_ASSOC_SUB_WIN.id]
  bypass                     = ["Metrics"]
}

data "azurerm_private_endpoint_connection" "MOD_END_POINT_CONNECTION" {
  name                = "PEC-STO-FS"
  resource_group_name = var.rs_name
}
