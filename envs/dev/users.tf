# -------------------------------------------------------
# TLS Key for the application service user
# -------------------------------------------------------
resource "tls_private_key" "app_user_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# -------------------------------------------------------
# Application Service User
# -------------------------------------------------------
resource "snowflake_user" "app_user" {
  provider          = snowflake.useradmin
  name              = "${var.project_prefix}_USER"
  default_warehouse = snowflake_warehouse.main.name
  default_role      = snowflake_account_role.app_role.name
  default_namespace = "${snowflake_database.main.name}.${snowflake_schema.main.fully_qualified_name}"
  rsa_public_key    = substr(tls_private_key.app_user_key.public_key_pem, 27, 398)
}

# Grant the application role to the application user
resource "snowflake_grant_account_role" "app_role_to_app_user" {
  provider  = snowflake.useradmin
  role_name = snowflake_account_role.app_role.name
  user_name = snowflake_user.app_user.name
}
