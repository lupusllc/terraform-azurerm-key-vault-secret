output "key_vault_secrets" {
  description = "The key vault secrets."
  value       = azurerm_key_vault_secret.this
}

### Debug Only

output "var_key_vault_secrets" {
  value = var.key_vault_secrets
}

output "local_key_vault_secrets" {
  value = local.key_vault_secrets
}

output "local_data_key_vaults" {
  value = local.data_key_vaults
}
