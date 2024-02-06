# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used.

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
  root_id        = var.root_id
  root_name      = var.root_name
  library_path   = "${path.root}/lib"

# Identiy & Management Subscription IDs

  deploy_identity_resources = true
  subscription_id_identity  = "9bb108f8-b5b7-4ba5-96f7-65f17ee59b93"
/*
  deploy_management_resources = true
  subscription_id_management  = "b1d61f03-47e1-4147-b8e8-ba6dc7092bed"
 /* 
  deploy_connectivity_resources = true
  subscription_id_connectivity  = "2e7e16b6-57de-4579-a09c-53b748eea49b"
  */
  custom_landing_zones = {
    "${var.root_id}-hippa-corp" = {
      display_name               = "${upper(var.root_id)} Hippa Corp"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "hippa-corp"
        parameters     = {}
        access_control = {}
      }
    }
    "${var.root_id}-non-hippa-corp" = {
      display_name               = "${upper(var.root_id)} Non-Hippa Corp"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = []
       archetype_config = {
        archetype_id   = "non-hippa-corp"
        parameters     = {}
        access_control = {}
      }  
    }
  }
}