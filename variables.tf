### Defaults

variable "defaults" {
  default     = {} # Defaults to an empty map.
  description = "Defaults used for resources when nothing is specified for the resource."
  nullable    = false # This will treat null values as unset, which will allow for use of defaults.
  type        = any
}

### Required

variable "required" {
  default     = {} # Defaults to an empty map.
  description = "Required resource values, as applicable."
  nullable    = false # This will treat null values as unset, which will allow for use of defaults.
  type        = any
}

### Dependencies

variable "key_vaults" {
  default     = {} # Defaults to an empty map.
  description = "Depedant Key Vault resource."
  nullable    = false # This will treat null values as unset, which will allow for use of defaults.
  type        = any
}

### Resources

variable "key_vault_secrets" {
  default     = [] # Defaults to an empty list.
  description = "Key Vault Secrets."
  nullable    = false # This will treat null values as unset, which will allow for use of defaults.
  type = list(object({
    ### Basic

    content_type                  = optional(string, null)
    expiration_date               = optional(string, null) # UTC datetime (Y-m-d'T'H:M:S'Z').
    key_vault_data_source         = optional(bool, false)  # Can use data source to lookup Key Vault id, id takes precedence.
    key_vault_id                  = optional(string, null) # Can use name or id, id takes precidence.
    key_vault_name                = optional(string, null) # Can use name and resource group or id, id takes precidence.
    key_vault_resource_group_name = optional(string, null) # Can use name and resource group or id, id takes precidence.
    name                          = string
    not_before_date               = optional(string, null) # UTC datetime (Y-m-d'T'H:M:S'Z').
    tags                          = optional(map(string), {})
    value_wo_version              = optional(number, null) # Increment this when value_wo changes, since it's write only, it can't verify values.
  }))
}

variable "key_vault_secrets_sensitive" {
  default     = [] # Defaults to an empty list.
  description = "Key Vault Secrets."
  nullable    = false # This will treat null values as unset, which will allow for use of defaults.
  type = list(object({
    ### Basic

    # These are needed to ensure they match the target resource.
    key_vault_id   = optional(string, null) # Can use name or id, id takes precidence.
    key_vault_name = optional(string, null) # Can use name and resource group or id, id takes precidence.
    name           = string

    ### Sensitive

    value    = optional(string, null)
    value_wo = optional(string, null) # Secret value, write only. Needs value_wo_version populated to signal when changes have occured.
  }))
  sensitive = true # To protect sensitive values.
}
