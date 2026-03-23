# -------------------------------------------------------
# Database
# -------------------------------------------------------
resource "snowflake_database" "main" {
  name         = "${var.project_prefix}_DB"
  is_transient = false
}

# -------------------------------------------------------
# Schema
# -------------------------------------------------------
resource "snowflake_schema" "main" {
  name                = "${var.project_prefix}_SCHEMA"
  database            = snowflake_database.main.name
  with_managed_access = false
}
