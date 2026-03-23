# -------------------------------------------------------
# Database-level grants
# -------------------------------------------------------
resource "snowflake_grant_privileges_to_account_role" "db_usage" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.app_role.name
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.main.name
  }
}

# -------------------------------------------------------
# Schema-level grants
# -------------------------------------------------------
resource "snowflake_grant_privileges_to_account_role" "schema_usage" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.app_role.name
  on_schema {
    schema_name = snowflake_schema.main.fully_qualified_name
  }
}

# -------------------------------------------------------
# Table-level grants (current tables)
# -------------------------------------------------------
resource "snowflake_grant_privileges_to_account_role" "select_all_tables" {
  provider          = snowflake.useradmin
  privileges        = ["SELECT"]
  account_role_name = snowflake_account_role.app_role.name
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema          = snowflake_schema.main.fully_qualified_name
    }
  }
}

# -------------------------------------------------------
# Table-level grants (future tables)
# -------------------------------------------------------
resource "snowflake_grant_privileges_to_account_role" "select_future_tables" {
  provider          = snowflake.useradmin
  privileges        = ["SELECT"]
  account_role_name = snowflake_account_role.app_role.name
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_schema          = snowflake_schema.main.fully_qualified_name
    }
  }
}

# -------------------------------------------------------
# Warehouse grants
# -------------------------------------------------------
resource "snowflake_grant_privileges_to_account_role" "warehouse_usage" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.app_role.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.main.name
  }
}
