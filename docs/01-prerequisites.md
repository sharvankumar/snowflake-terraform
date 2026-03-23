# 01 - Prerequisites

Before you begin, ensure you have the following tools and access.

## Required Tools

| Tool | Version | Install |
|------|---------|---------|
| Terraform | >= 1.5.0 | `brew tap hashicorp/tap && brew install hashicorp/tap/terraform` |
| OpenSSL | any | Pre-installed on macOS |
| Git | any | `brew install git` |

Verify installations:

```bash
terraform version
openssl version
git --version
```

## Required Access

- **Snowflake Account** with `ACCOUNTADMIN` role access
- **GitHub Account** with push access to the repository

## Account Information

Your Snowflake account identifier is split into two parts:

| Field | Value | Description |
|-------|-------|-------------|
| Organization Name | `JLCUCPS` | First part of the account identifier |
| Account Name | `NC57185` | Second part of the account identifier |
| Console URL | https://jlcucps-nc57185.snowflakecomputing.com | Snowflake web console |

You can verify these by running this SQL in the Snowflake console:

```sql
SELECT LOWER(current_organization_name()) AS org_name,
       LOWER(current_account_name())      AS account_name;
```

## Next Step

Proceed to [02 - Snowflake Account Setup](./02-snowflake-account-setup.md).
