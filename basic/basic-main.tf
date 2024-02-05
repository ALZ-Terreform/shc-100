# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.74.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# You can use the azurerm_client_config data resource to dynamically
# extract connection settings from the provider configuration.

data "azurerm_client_config" "core" {}

# Call the caf-enterprise-scale module directly from the Terraform Registry
# pinning to the latest version

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "5.0.3" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  default_location = "westus"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
    
  }

  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = "shc-1"
  root_name      = "Standford Health Care 1"

  deploy_identity_resources = true
  subscription_id_identity  = "9bb108f8-b5b7-4ba5-96f7-65f17ee59b93"

  deploy_management_resources = true
  subscription_id_management  = "b1d61f03-47e1-4147-b8e8-ba6dc7092bed"
}