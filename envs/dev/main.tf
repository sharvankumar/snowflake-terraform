terraform {
  required_version = ">= 1.5.0"

  required_providers {
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = "~> 1.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

locals {
  organization_name = var.snowflake_organization_name
  account_name      = var.snowflake_account_name
  private_key_path  = var.snowflake_private_key_path
}

# -------------------------------------------------------
# Provider: SYSADMIN
# Used for creating databases, schemas, warehouses
# -------------------------------------------------------
provider "snowflake" {
  organization_name = local.organization_name
  account_name      = local.account_name
  user              = var.snowflake_user
  role              = "SYSADMIN"
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = file(local.private_key_path)
}

# -------------------------------------------------------
# Provider: USERADMIN
# Used for creating users, roles, and grants
# -------------------------------------------------------
provider "snowflake" {
  organization_name = local.organization_name
  account_name      = local.account_name
  user              = var.snowflake_user
  role              = "USERADMIN"
  alias             = "useradmin"
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = file(local.private_key_path)
}
