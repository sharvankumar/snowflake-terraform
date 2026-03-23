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

output "role_read" {
  description = "Name of the READ role"
  value       = snowflake_account_role.read.name
}

output "role_ddl" {
  description = "Name of the DDL role"
  value       = snowflake_account_role.ddl.name
}

output "role_dml" {
  description = "Name of the DML role"
  value       = snowflake_account_role.dml.name
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
