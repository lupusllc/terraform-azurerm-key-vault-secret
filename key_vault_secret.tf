### Requirements:

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.54.0" # Tested on this provider version, but will allow future patch versions.
    }
  }
  required_version = "~> 1.14.0" # Tested on this Terraform CLI version, but will allow future patch versions.
}

### Data:

### Resources:

resource "azurerm_key_vault_secret" "this" {
  for_each = local.key_vault_secrets

  ### Basic
  content_type     = each.value.content_type
  expiration_date  = each.value.expiration_date
  key_vault_id     = each.value.key_vault_id
  name             = each.value.name
  not_before_date  = each.value.not_before_date
  tags             = each.value.tags
  value_wo_version = each.value.value_wo_version

  ### Sensitive
  value    = local.key_vault_secrets_sensitive[each.key].value
  value_wo = local.key_vault_secrets_sensitive[each.key].value_wo
}
