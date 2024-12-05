#Criação VNET + SUBNETS
resource "azurerm_virtual_network" "MOD_VNET01" {
  name                = "VNET01"
  location            = var.rs_location
  resource_group_name = var.rs_name
  address_space       = ["10.0.0.0/16"]
  tags = {
    name = "Ambiente"
    environment = "Storage Account"
  }
}
resource "azurerm_subnet" "MOD_SUB-WIN" {
  name                 = "SUB-WIN"
  resource_group_name  = var.rs_name
  virtual_network_name = azurerm_virtual_network.MOD_VNET01.name
  address_prefixes     = ["10.0.0.0/24"]
  
}
resource "azurerm_subnet" "MOD_SUB-LNX" {
  name                 = "SUB-LNX"
  resource_group_name  = var.rs_name
  virtual_network_name = azurerm_virtual_network.MOD_VNET01.name
  address_prefixes     = ["10.0.1.0/24"]
}

#Criação PIP + Network Interface para VM-Linux + VM LINUX + NSG PARA ACESSO 22
##############################################################################
resource "azurerm_public_ip" "MOD_PIP-LINUX" {
  name                = "PublicIp1_linux"
  resource_group_name = var.rs_name
  location            = var.rs_location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "MOD_NIC_LINUX" {
  name                = "NIC_LNX"
  location            = var.rs_location
  resource_group_name = var.rs_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.MOD_SUB-LNX.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.MOD_PIP-LINUX.id
  }
}
resource "azurerm_virtual_machine" "MOD_VM_LINUX" {
  name                  = "VM-LINUX"
  location              = var.rs_location
  resource_group_name   = var.rs_name
  network_interface_ids = [azurerm_network_interface.MOD_NIC_LINUX.id,]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk-tftec-from-terraform"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "tftecprime"
    admin_username = "adminuser"
    admin_password = "Password12345!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  delete_os_disk_on_termination = true
 
}
resource "azurerm_network_security_group" "MOD_NSG_LINUX" {
  name                = "NSG_VM_LINUX"
  location            = var.rs_location
  resource_group_name = var.rs_name

  security_rule {
    name                       = "SSH"
    priority                   = 115
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "MOD_NSG_ASSOC_SUB_LINUX" {
  subnet_id                 = azurerm_subnet.MOD_SUB-LNX.id
  network_security_group_id = azurerm_network_security_group.MOD_NSG_LINUX.id
}

#Criação PIP + Network Interface para VM-Windows + VM WINDOWS + NSG PARA ACESSO 3389
####################################################################################
resource "azurerm_public_ip" "MOD_PIP-WIN" {
  name                = "PublicIp1_win"
  resource_group_name = var.rs_name
  location            = var.rs_location
  allocation_method   = "Static"
}
resource "azurerm_network_interface" "MOD_NIC_WINDOWS" {
  name                = "NIC_WINDOWS"
  location            = var.rs_location
  resource_group_name = var.rs_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.MOD_SUB-WIN.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.MOD_PIP-WIN.id
  }
}
resource "azurerm_windows_virtual_machine" "MOD_VM_WINDOWS" {
  name                = "VMWINDOWS"
  resource_group_name = var.rs_name
  location            = var.rs_location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.MOD_NIC_WINDOWS.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
resource "azurerm_network_security_group" "MOD_NSG_WIN" {
  name                = "NSG_VM_WINDOWS"
  location            = var.rs_location
  resource_group_name = var.rs_name

  security_rule {
    name                       = "RDP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "MOD_NSG_ASSOC_SUB_WIN" {
  subnet_id                 = azurerm_subnet.MOD_SUB-WIN.id
  network_security_group_id = azurerm_network_security_group.MOD_NSG_WIN.id
}
