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

resource "azurerm_resource_group" "resource_group_1" {
  name     = var.resource_group_name
  location = "eastus"

  tags = {
    "name" = "resource-group-one"
  }
}

# done - my user
# done - trainer user 
# done - 4 for_each users
# done - 2 s3 buckets
# resource group on azure with a 
# - vm
# - storage account
# 2 tags
# 1 output variable
# 5 variables 

# MOVE VARIABLES INTO variables.tf
