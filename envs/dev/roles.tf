# Role naming convention: {DATABASE}_{SCHEMA}_{ACCESS_LEVEL}
# This makes it immediately clear what each role can access and at what level.

locals {
  role_prefix = "${snowflake_database.main.name}_${snowflake_schema.main.name}"
}

# -------------------------------------------------------
# READ role — SELECT on tables and views
# -------------------------------------------------------
resource "snowflake_account_role" "read" {
  provider = snowflake.useradmin
  name     = "${local.role_prefix}_READ"
  comment  = "Read-only access to ${snowflake_database.main.name}.${snowflake_schema.main.name}"
}

resource "snowflake_grant_account_role" "read_to_sysadmin" {
  provider         = snowflake.useradmin
  role_name        = snowflake_account_role.read.name
  parent_role_name = "SYSADMIN"
}

# -------------------------------------------------------
# DDL role — CREATE, ALTER, DROP schema objects
# -------------------------------------------------------
resource "snowflake_account_role" "ddl" {
  provider = snowflake.useradmin
  name     = "${local.role_prefix}_DDL"
  comment  = "DDL access to ${snowflake_database.main.name}.${snowflake_schema.main.name}"
}

resource "snowflake_grant_account_role" "ddl_to_sysadmin" {
  provider         = snowflake.useradmin
  role_name        = snowflake_account_role.ddl.name
  parent_role_name = "SYSADMIN"
}

# -------------------------------------------------------
# DML role — INSERT, UPDATE, DELETE, TRUNCATE
# -------------------------------------------------------
resource "snowflake_account_role" "dml" {
  provider = snowflake.useradmin
  name     = "${local.role_prefix}_DML"
  comment  = "DML access to ${snowflake_database.main.name}.${snowflake_schema.main.name}"
}

resource "snowflake_grant_account_role" "dml_to_sysadmin" {
  provider         = snowflake.useradmin
  role_name        = snowflake_account_role.dml.name
  parent_role_name = "SYSADMIN"
}
