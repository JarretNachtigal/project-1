terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.45.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "4.57.0"
    }
  }
}

# my user
resource "azuread_user" "my_user" {
  user_principal_name = "jarret.nachtigal@someemail.com"
  display_name        = "Jarret Nachtigal"
  mail_nickname       = "jnachtigal"
  password            = "SecretP@sswd99!"
}

# trainer's user
resource "azuread_user" "trainer_user" {
  user_principal_name   = "ibrahim.ozbekler@someemail.com"
  display_name          = "Ibrahim Ozbekler"
  mail_nickname         = "iozbekler"
  password              = "SecretP@sswd99!"
  force_password_change = true
}

# 4 users from for_each
resource "azuread_user" "trainer_users_from_for_each" {
  user_principal_name = each.value[0]
  display_name        = each.value[1]
  mail_nickname       = each.value[2]
  password            = each.value[3]
  for_each            = toset(var.display_names)
}

resource "aws_s3_bucket" "b" {
  count  = var.num_buckets
  bucket = "my-tf-test-bucket-${count.index}"

  tags = {
    Name        = "My bucket${count.index}"
    Environment = "Dev"
  }
}

# resource group
resource "azurerm_resource_group" "resource_group_1" {
  name     = var.resource_group_name
  location = "eastus"

  tags = {
    "name" = "resource-group-one"
  }
}

# virtual machine dependency
resource "azurerm_virtual_network" "main" {
  name                = "my-vet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.resource_group_1.location
  resource_group_name = azurerm_resource_group.resource_group_1.name
}

# virtual machine dependency
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.resource_group_1.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# virtual machine dependency
resource "azurerm_network_interface" "main" {
  name                = "my-nic"
  location            = azurerm_resource_group.resource_group_1.location
  resource_group_name = azurerm_resource_group.resource_group_1.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

# virtual machine
resource "azurerm_virtual_machine" "main" {
  name                  = "my-vm"
  location              = azurerm_resource_group.resource_group_1.location
  resource_group_name   = azurerm_resource_group.resource_group_1.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

# storage account
resource "azurerm_storage_account" "storage_account_1" {
  name                     = "mystorageaccount"
  resource_group_name      = azurerm_resource_group.resource_group_1.name
  location                 = azurerm_resource_group.resource_group_1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "dev"
  }
}

# done - my user
# done - trainer user 
# done - 4 for_each users
# done - 2 s3 buckets
# resource group on azure with a 
# done - vm
# - storage account
# done - 2 tags
# 1 output variable
# 5 variables 

# MOVE VARIABLES INTO variables.tf
