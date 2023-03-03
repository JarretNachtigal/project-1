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
  user_principal_name = "ibrahim.ozbekler@someemail.com"
  display_name        = each.value
  mail_nickname       = "iozbekler"
  password            = "SecretP@sswd99!"
  for_each            = toset(var.display_names)
}

variable "display_names" {
  default = ["jon johnson", "tom Thomson", "bob bobson", "jan janson"]
}

# my user
# trainer user 
# 4 for_each users
# 2 s3 buckets
# resource group  on azure with a 
# - vm
# - storage account
# 2 tags
# 1 output variable
# variables where possible
