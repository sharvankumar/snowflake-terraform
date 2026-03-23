-- =============================================================
-- Snowflake Service User Setup for Terraform
-- =============================================================
-- Run this SQL in the Snowflake console as ACCOUNTADMIN
-- This creates a service user that Terraform uses to authenticate
-- via RSA key pair (no password or MFA required).
-- =============================================================

USE ROLE ACCOUNTADMIN;

-- Create the Terraform service user (TYPE = SERVICE means no login/password)
CREATE USER IF NOT EXISTS TERRAFORM_SVC
    TYPE = SERVICE
    COMMENT = 'Service user for Terraforming Snowflake';

-- Set the RSA public key for the service user
-- Replace <RSA_PUBLIC_KEY_HERE> with the contents of ~/.ssh/snowflake_tf_snow_key.pub
-- Include the -----BEGIN PUBLIC KEY----- and -----END PUBLIC KEY----- lines
ALTER USER TERRAFORM_SVC SET RSA_PUBLIC_KEY = '<RSA_PUBLIC_KEY_HERE>';

-- Grant required roles to the service user
-- SYSADMIN:      Create databases, schemas, warehouses
-- SECURITYADMIN: Manage roles and grants (parent of USERADMIN)
GRANT ROLE SYSADMIN TO USER TERRAFORM_SVC;
GRANT ROLE SECURITYADMIN TO USER TERRAFORM_SVC;

-- Verify the user was created correctly
DESCRIBE USER TERRAFORM_SVC;

-- =============================================================
-- CLEANUP (run when you want to remove Terraform access)
-- =============================================================
-- DROP USER IF EXISTS TERRAFORM_SVC;
