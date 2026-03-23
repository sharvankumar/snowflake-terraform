# 02 - Snowflake Account Setup

This step creates a service user in Snowflake that Terraform authenticates as using RSA key pairs (no password or MFA needed).

## Step 1: Generate RSA Key Pair

Run the helper script from the project root:

```bash
./scripts/generate-keys.sh
```

This creates two files:
- `~/.ssh/snowflake_tf_snow_key.p8` — Private key (used by Terraform, never share this)
- `~/.ssh/snowflake_tf_snow_key.pub` — Public key (registered in Snowflake)

## Step 2: Create the Service User in Snowflake

1. Log in to the [Snowflake Console](https://jlcucps-nc57185.snowflakecomputing.com) as a user with `ACCOUNTADMIN` role.
2. Open a SQL Worksheet.
3. Copy the contents of your **public key** file:

```bash
cat ~/.ssh/snowflake_tf_snow_key.pub
```

4. Run the following SQL, replacing `<RSA_PUBLIC_KEY_HERE>` with your public key (include the BEGIN/END lines):

```sql
USE ROLE ACCOUNTADMIN;

CREATE USER IF NOT EXISTS TERRAFORM_SVC
    TYPE = SERVICE
    COMMENT = 'Service user for Terraforming Snowflake';

ALTER USER TERRAFORM_SVC SET RSA_PUBLIC_KEY = '<RSA_PUBLIC_KEY_HERE>';

GRANT ROLE SYSADMIN TO USER TERRAFORM_SVC;
GRANT ROLE SECURITYADMIN TO USER TERRAFORM_SVC;
```

> The full SQL script is also available at `scripts/snowflake-service-user.sql`.

## Step 3: Create the Terraform Variables File

```bash
cd envs/dev
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your actual values. This file is git-ignored and will never be committed.

## Verify

Run this SQL to confirm the user exists:

```sql
DESCRIBE USER TERRAFORM_SVC;
```

## Next Step

Proceed to [03 - Terraform Workflow](./03-terraform-workflow.md).
