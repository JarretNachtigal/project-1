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
  user_principal_name = "ibrahim.ozbekler@someemail.com"
  display_name        = "Ibrahim Ozbekler"
  mail_nickname       = "iozbekler"
  password            = "SecretP@sswd99!"
}
