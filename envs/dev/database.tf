# -------------------------------------------------------
# Database
# -------------------------------------------------------
resource "snowflake_database" "main" {
  name         = var.database_name
  is_transient = false
}

# -------------------------------------------------------
# Schema
# -------------------------------------------------------
resource "snowflake_schema" "main" {
  name                = var.schema_name
  database            = snowflake_database.main.name
  with_managed_access = false
}
