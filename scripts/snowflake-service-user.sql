-- =============================================================
-- Snowflake Service User Setup for Terraform
-- =============================================================
-- Run this SQL in the Snowflake console as ACCOUNTADMIN
-- This creates a service user that Terraform uses to authenticate
-- via RSA key pair (no password or MFA required).
-- =============================================================

USE ROLE ACCOUNTADMIN;

-- =============================================================
-- STEP 1: Get your Account Identifier
-- =============================================================
-- Run this query to get the org and account names.
-- These values go into envs/<env>/terraform.tfvars as:
--   snowflake_organization_name = "<your_org_name>"
--   snowflake_account_name      = "<your_account_name>"
--
-- The account identifier format is: <org_name>-<account_name>
-- Example: JLCUCPS-NC57185 → org = JLCUCPS, account = NC57185
-- You can also derive these from your Snowflake console URL:
--   https://<org>-<account>.snowflakecomputing.com
-- =============================================================

SELECT CURRENT_ORGANIZATION_NAME() AS organization_name,
       CURRENT_ACCOUNT_NAME()      AS account_name;

-- =============================================================
-- STEP 2: Create the Terraform service user
-- =============================================================
-- TYPE = SERVICE means no login/password, key-pair auth only.

CREATE USER IF NOT EXISTS TERRAFORM_SVC
    TYPE = SERVICE
    COMMENT = 'Service user for Terraforming Snowflake';

-- =============================================================
-- STEP 3: Set the RSA public key
-- =============================================================
-- Generate the key pair first by running: ./scripts/generate-keys.sh
-- Then paste the contents of ~/.ssh/snowflake_tf_snow_key.pub below.
-- Include the -----BEGIN PUBLIC KEY----- and -----END PUBLIC KEY----- lines.

ALTER USER TERRAFORM_SVC SET RSA_PUBLIC_KEY = '<RSA_PUBLIC_KEY_HERE>';

-- =============================================================
-- STEP 4: Grant required roles
-- =============================================================
-- SYSADMIN:      Create databases, schemas, warehouses
-- SECURITYADMIN: Manage roles and grants (parent of USERADMIN)

GRANT ROLE SYSADMIN TO USER TERRAFORM_SVC;
GRANT ROLE SECURITYADMIN TO USER TERRAFORM_SVC;

-- =============================================================
-- STEP 5: Verify everything
-- =============================================================

DESCRIBE USER TERRAFORM_SVC;
SHOW GRANTS TO USER TERRAFORM_SVC;

-- =============================================================
-- CLEANUP (run when you want to remove Terraform access)
-- =============================================================
-- DROP USER IF EXISTS TERRAFORM_SVC;
