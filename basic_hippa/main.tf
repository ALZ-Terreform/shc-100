# Get the current client configuration from the AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID used as the ID for the "Tenant Root Group"
# Management Group.

data "azurerm_client_config" "core" {}

# Declare the Azure landing zones Terraform module
# and provide a base configuration.

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

#  identity
  deploy_identity_resources = true
  subscription_id_identity  = data.azurerm_client_config.core.subscription_id
# management
  deploy_management_resources = true
  subscription_id_management  = data.azurerm_client_config.core.subscription_id

  custom_landing_zones = {
    "${var.root_id}-hippa-corp" = {
      display_name               = "${upper(var.root_id)} Hippa Corp"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = []
    }
    "${var.root_id}-non-hippa-corp" = {
      display_name               = "${upper(var.root_id)} Non-Hippa Corp"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = []
    }
  }
}