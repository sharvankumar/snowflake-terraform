# -------------------------------------------------------
# Snowflake Connection
# -------------------------------------------------------

variable "snowflake_organization_name" {
  description = "Snowflake organization name (first part of account identifier)"
  type        = string
}

variable "snowflake_account_name" {
  description = "Snowflake account name (second part of account identifier)"
  type        = string
}

variable "snowflake_user" {
  description = "Snowflake service user for Terraform"
  type        = string
  default     = "TERRAFORM_SVC"
}

variable "snowflake_private_key_path" {
  description = "Path to the RSA private key file for authentication"
  type        = string
  default     = "~/.ssh/snowflake_tf_snow_key.p8"
}

# -------------------------------------------------------
# Resource Naming
# -------------------------------------------------------

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_prefix" {
  description = "Prefix for all Snowflake object names"
  type        = string
  default     = "TF_DEMO"
}

# -------------------------------------------------------
# Warehouse Configuration
# -------------------------------------------------------

variable "warehouse_size" {
  description = "Size of the virtual warehouse"
  type        = string
  default     = "XSMALL"

  validation {
    condition     = contains(["XSMALL", "SMALL", "MEDIUM", "LARGE", "XLARGE"], var.warehouse_size)
    error_message = "Warehouse size must be one of: XSMALL, SMALL, MEDIUM, LARGE, XLARGE."
  }
}

variable "warehouse_auto_suspend" {
  description = "Seconds of inactivity before auto-suspending the warehouse"
  type        = number
  default     = 60
}
