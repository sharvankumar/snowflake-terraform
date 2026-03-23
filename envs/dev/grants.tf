# =============================================================
# READ role grants
# =============================================================

resource "snowflake_grant_privileges_to_account_role" "read_db_usage" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.read.name
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.main.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "read_schema_usage" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.read.name
  on_schema {
    schema_name = snowflake_schema.main.fully_qualified_name
  }
}

resource "snowflake_grant_privileges_to_account_role" "read_wh_usage" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.read.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.main.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "read_select_all_tables" {
  provider          = snowflake.useradmin
  privileges        = ["SELECT"]
  account_role_name = snowflake_account_role.read.name
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema          = snowflake_schema.main.fully_qualified_name
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "read_select_future_tables" {
  provider          = snowflake.useradmin
  privileges        = ["SELECT"]
  account_role_name = snowflake_account_role.read.name
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_schema          = snowflake_schema.main.fully_qualified_name
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "read_select_all_views" {
  provider          = snowflake.useradmin
  privileges        = ["SELECT"]
  account_role_name = snowflake_account_role.read.name
  on_schema_object {
    all {
      object_type_plural = "VIEWS"
      in_schema          = snowflake_schema.main.fully_qualified_name
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "read_select_future_views" {
  provider          = snowflake.useradmin
  privileges        = ["SELECT"]
  account_role_name = snowflake_account_role.read.name
  on_schema_object {
    future {
      object_type_plural = "VIEWS"
      in_schema          = snowflake_schema.main.fully_qualified_name
    }
  }
}

# =============================================================
# DDL role grants
# =============================================================

resource "snowflake_grant_privileges_to_account_role" "ddl_db_usage" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.ddl.name
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.main.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "ddl_schema_usage" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.ddl.name
  on_schema {
    schema_name = snowflake_schema.main.fully_qualified_name
  }
}

resource "snowflake_grant_privileges_to_account_role" "ddl_wh_usage" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.ddl.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.main.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "ddl_schema_create" {
  provider          = snowflake.useradmin
  privileges        = ["CREATE TABLE", "CREATE VIEW", "CREATE STAGE", "CREATE FILE FORMAT", "CREATE SEQUENCE", "CREATE FUNCTION", "CREATE PROCEDURE"]
  account_role_name = snowflake_account_role.ddl.name
  on_schema {
    schema_name = snowflake_schema.main.fully_qualified_name
  }
}

# =============================================================
# DML role grants
# =============================================================

resource "snowflake_grant_privileges_to_account_role" "dml_db_usage" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.dml.name
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.main.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "dml_schema_usage" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.dml.name
  on_schema {
    schema_name = snowflake_schema.main.fully_qualified_name
  }
}

resource "snowflake_grant_privileges_to_account_role" "dml_wh_usage" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.dml.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.main.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "dml_all_tables" {
  provider          = snowflake.useradmin
  privileges        = ["INSERT", "UPDATE", "DELETE", "TRUNCATE"]
  account_role_name = snowflake_account_role.dml.name
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema          = snowflake_schema.main.fully_qualified_name
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "dml_future_tables" {
  provider          = snowflake.useradmin
  privileges        = ["INSERT", "UPDATE", "DELETE", "TRUNCATE"]
  account_role_name = snowflake_account_role.dml.name
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_schema          = snowflake_schema.main.fully_qualified_name
    }
  }
}
