# -------------------------------------------------------
# Resource identifiers
# -------------------------------------------------------
output "database_name" {
  description = "Name of the created database"
  value       = snowflake_database.main.name
}

output "schema_name" {
  description = "Fully qualified name of the created schema"
  value       = snowflake_schema.main.fully_qualified_name
}

output "warehouse_name" {
  description = "Name of the created warehouse"
  value       = snowflake_warehouse.main.name
}

output "role_name" {
  description = "Name of the created role"
  value       = snowflake_account_role.app_role.name
}

output "user_name" {
  description = "Name of the created user"
  value       = snowflake_user.app_user.name
}

# -------------------------------------------------------
# Application user keys (for downstream services)
# -------------------------------------------------------
output "app_user_public_key" {
  description = "Public key for the application service user"
  value       = tls_private_key.app_user_key.public_key_pem
}

output "app_user_private_key" {
  description = "Private key for the application service user (sensitive)"
  value       = tls_private_key.app_user_key.private_key_pem
  sensitive   = true
}
