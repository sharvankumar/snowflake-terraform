# Snowflake Terraform

Infrastructure as Code (IaC) for managing Snowflake account resources using Terraform.

## What This Creates

| Resource | Name | Description |
|----------|------|-------------|
| Database | `TF_DEMO_DB` | Main database |
| Schema | `TF_DEMO_SCHEMA` | Default schema in the database |
| Warehouse | `TF_DEMO_WH` | XS virtual warehouse (auto-suspend 60s) |
| Role | `TF_DEMO_ROLE` | Application role with SELECT on tables |
| User | `TF_DEMO_USER` | Service user with RSA key authentication |
| Grants | Various | USAGE on DB/Schema/WH, SELECT on current + future tables |

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

### 3. Create Snowflake Service User

Run the SQL in `scripts/snowflake-service-user.sql` in the Snowflake console as `ACCOUNTADMIN`. See [docs/02-snowflake-account-setup.md](docs/02-snowflake-account-setup.md) for details.

### 4. Configure Variables

```bash
cd envs/dev
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

### 5. Initialize & Apply

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

## Snowflake Account

| Field | Value |
|-------|-------|
| Account Identifier | `JLCUCPS-NC57185` |
| Console | https://jlcucps-nc57185.snowflakecomputing.com |

## References

- [Snowflake Terraform Provider Docs](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs)
- [Terraforming Snowflake Guide](https://www.snowflake.com/en/developers/guides/terraforming-snowflake/)
- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
