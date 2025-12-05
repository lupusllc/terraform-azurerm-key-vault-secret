# Helps to combine data, easier debug and remove complexity in the main resource.

locals {
  key_vault_secrets_list = [
    for index, settings in var.key_vault_secrets : {
      # Most will try and use key/value settings first, then try applicable defaults and then null as a last resort.

      ### Basic

      content_type    = settings.content_type
      expiration_date = settings.expiration_date
      index           = index # Added in case it's ever needed, since for_each/for loops don't have inherent indexes.
      # If key_vault_id is provided, use it directly.
      key_vault_id = settings.key_vault_id != null ? settings.key_vault_id : (
        # Otherwise, if key_vault_name and key_vault_resource_group_name are provided, construct the key_vault_id.
        settings.key_vault_name != null && settings.key_vault_resource_group_name != null ? format(
          "/subscriptions/%s/resourceGroups/%s/providers/Microsoft.KeyVault/vaults/%s",
          data.azurerm_client_config.current.subscription_id,
          settings.key_vault_resource_group_name,
          settings.key_vault_name
        ) : null
      )
      # If key_vault_id is not null, split out name to populate key_vault_name. If null, use key_vault_name directly.
      key_vault_name = settings.key_vault_id != null ? element(split("/", settings.key_vault_id), 8) : settings.key_vault_name
      # If key_vault_id is not null, split out resource group name to populate key_vault_resource_group_name. If null, use key_vault_resource_group_name directly.
      key_vault_resource_group_name = settings.key_vault_id != null ? element(split("/", settings.key_vault_id), 4) : settings.key_vault_resource_group_name

      name            = settings.name
      not_before_date = settings.not_before_date

      # Merges settings or default tags with required tags.
      tags = merge(
        # Count settings tags, if greater than 0 use them, otherwise try defaults tags if they exist, if not use a blank map. 
        length(settings.tags) > 0 ? settings.tags : try(var.defaults.tags, {}),
        try(var.required.tags, {})
      )

      value_wo_version = settings.value_wo_version
    }
  ]

  # Since we can't use sensitive values in for_each for security reasons, we must put sensitive items in their own variable and reference them that way.
  key_vault_secrets_sensitive_list = [
    for index, settings in var.key_vault_secrets_sensitive : {
      # Most will try and use key/value settings first, then try applicable defaults and then null as a last resort.

      ### Basic

      index = index # Added in case it's ever needed, since for_each/for loops don't have inherent indexes.
      # If key_vault_id is provided, use it directly.
      key_vault_id = settings.key_vault_id != null ? settings.key_vault_id : (
        # Otherwise, if key_vault_name and key_vault_resource_group_name are provided, construct the key_vault_id.
        settings.key_vault_name != null && settings.key_vault_resource_group_name != null ? format(
          "/subscriptions/%s/resourceGroups/%s/providers/Microsoft.KeyVault/vaults/%s",
          data.azurerm_client_config.current.subscription_id,
          settings.key_vault_resource_group_name,
          settings.key_vault_name
        ) : null
      )
      # If key_vault_id is not null, split out name to populate key_vault_name. If null, use key_vault_name directly.
      key_vault_name = settings.key_vault_id != null ? element(split("/", settings.key_vault_id), 8) : settings.key_vault_name
      # If key_vault_id is not null, split out resource group name to populate key_vault_resource_group_name. If null, use key_vault_resource_group_name directly.
      key_vault_resource_group_name = settings.key_vault_id != null ? element(split("/", settings.key_vault_id), 4) : settings.key_vault_resource_group_name
      name                          = settings.name

      ### Sensitive

      value    = sensitive(settings.value)
      value_wo = sensitive(settings.value_wo)
    }
  ]

  # Used to create unique id for for_each loops, as just using the name may not be unique.
  key_vault_secrets = {
    for index, settings in local.key_vault_secrets_list : "${settings.key_vault_resource_group_name}>${settings.key_vault_name}>${settings.name}" => settings
  }

  # Used to create unique id for for_each loops, as just using the name may not be unique.
  key_vault_secrets_sensitive = {
    for index, settings in local.key_vault_secrets_sensitive_list : "${settings.key_vault_resource_group_name}>${settings.key_vault_name}>${settings.name}" => settings
  }
}
