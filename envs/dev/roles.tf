# -------------------------------------------------------
# Application Role
# -------------------------------------------------------
resource "snowflake_account_role" "app_role" {
  provider = snowflake.useradmin
  name     = "${var.project_prefix}_ROLE"
  comment  = "Terraform-managed role for ${var.environment} environment"
}

# Best practice: grant the new role to SYSADMIN so it stays in the role hierarchy
resource "snowflake_grant_account_role" "app_role_to_sysadmin" {
  provider         = snowflake.useradmin
  role_name        = snowflake_account_role.app_role.name
  parent_role_name = "SYSADMIN"
}
