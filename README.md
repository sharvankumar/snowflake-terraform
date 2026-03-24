# Snowflake Terraform — E-Commerce Analytics

Infrastructure as Code (IaC) for managing a Snowflake e-commerce analytics platform using Terraform.

## What This Creates

| Resource | Name | Description |
|----------|------|-------------|
| Database | `ECOM_ANALYTICS` | Central analytics database for e-commerce data |
| Schema | `SALES` | Orders, transactions, revenue, customer purchase data |
| Warehouse | `ECOM_ANALYTICS_WH` | XS compute warehouse for analytics queries and BI |
| Role | `ECOM_ANALYTICS_SALES_READ` | Read-only: SELECT on tables and views |
| Role | `ECOM_ANALYTICS_SALES_DDL` | DDL: CREATE, ALTER, DROP schema objects |
| Role | `ECOM_ANALYTICS_SALES_DML` | DML: INSERT, UPDATE, DELETE, TRUNCATE |
| User | `ECOM_ANALYTICS_SVC` | Service user with RSA key authentication |
| Grants | Various | USAGE on DB/Schema/WH + role-specific privileges |

## Project Structure

```
.
├── README.md                          # This file
├── .gitignore                         # Git ignore rules
├── docs/
│   ├── 01-prerequisites.md            # Tools & access requirements
│   ├── 02-snowflake-account-setup.md  # Service user creation in Snowflake
│   ├── 03-terraform-workflow.md       # init, plan, apply, destroy
│   └── 04-lifecycle-management.md     # Managing changes over time
├── envs/
│   └── dev/
│       ├── main.tf                    # Provider configuration
│       ├── variables.tf               # Variable declarations
│       ├── terraform.tfvars.example   # Example values (safe to commit)
│       ├── outputs.tf                 # Output values
│       ├── database.tf                # Database & schema
│       ├── warehouse.tf               # Warehouse
│       ├── roles.tf                   # Roles
│       ├── users.tf                   # Users & keys
│       └── grants.tf                  # Privileges & grants
└── scripts/
    ├── generate-keys.sh               # RSA key pair generation
    └── snowflake-service-user.sql     # SQL to create Terraform service user
```

### Why This Structure?

- **`envs/`** — Each environment (dev, staging, prod) gets its own directory with independent state. Add `envs/prod/` when ready.
- **Split `.tf` files** — Resources are grouped by type (database, warehouse, roles, etc.) instead of one large `main.tf`, making it easy to find and modify specific resources.
- **`scripts/`** — One-time setup scripts that are referenced by documentation.
- **`docs/`** — Step-by-step guides numbered in execution order.

## Quick Start

### 1. Install Prerequisites

```bash
brew tap hashicorp/tap && brew install hashicorp/tap/terraform
```

### 2. Generate RSA Keys

```bash
./scripts/generate-keys.sh
```

### 3. Get Your Snowflake Account Identifier

Run this SQL in the Snowflake console to get your org and account names:

```sql
SELECT CURRENT_ORGANIZATION_NAME() AS organization_name,
       CURRENT_ACCOUNT_NAME()      AS account_name;
```

These map to your console URL as: `https://<org>-<account>.snowflakecomputing.com`

### 4. Create Snowflake Service User

Run the SQL in `scripts/snowflake-service-user.sql` in the Snowflake console as `ACCOUNTADMIN`. The script walks you through each step. See [docs/02-snowflake-account-setup.md](docs/02-snowflake-account-setup.md) for full details.

### 5. Configure Variables

```bash
cd envs/dev
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with the values from step 3:

| Variable | Where to get it | Example |
|---|---|---|
| `snowflake_organization_name` | `CURRENT_ORGANIZATION_NAME()` or URL before the hyphen | `JLCUCPS` |
| `snowflake_account_name` | `CURRENT_ACCOUNT_NAME()` or URL after the hyphen | `NC57185` |
| `snowflake_user` | The service user created in step 4 | `TERRAFORM_SVC` |
| `snowflake_private_key_path` | Path to private key from step 2 | `~/.ssh/snowflake_tf_snow_key.p8` |
| `database_name` | Your choice | `ECOM_ANALYTICS` |
| `schema_name` | Your choice | `SALES` |
| `warehouse_name` | Your choice | `ECOM_ANALYTICS_WH` |
| `service_user_name` | Your choice | `ECOM_ANALYTICS_SVC` |
| `warehouse_size` | `XSMALL` / `SMALL` / `MEDIUM` / `LARGE` / `XLARGE` | `XSMALL` |

> **Note:** `terraform.tfvars` is git-ignored and never committed. The `.tfvars.example` file serves as a safe-to-commit template.

### 6. Initialize & Apply

```bash
cd envs/dev
terraform init
terraform plan
terraform apply
```

## Making Changes

```bash
# 1. Edit the relevant .tf file
# 2. Preview changes
terraform plan

# 3. Apply changes
terraform apply
```

See [docs/04-lifecycle-management.md](docs/04-lifecycle-management.md) for detailed change scenarios including resizing warehouses, adding schemas, managing roles, handling drift, and more.

## Cleanup

To destroy all Terraform-managed resources:

```bash
cd envs/dev
terraform destroy
```

Then remove the service user in Snowflake:

```sql
USE ROLE ACCOUNTADMIN;
DROP USER IF EXISTS TERRAFORM_SVC;
```

## References

- [Snowflake Terraform Provider Docs](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs)
- [Terraforming Snowflake Guide](https://www.snowflake.com/en/developers/guides/terraforming-snowflake/)
- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
