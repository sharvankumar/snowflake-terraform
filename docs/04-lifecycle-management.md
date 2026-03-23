# 04 - Lifecycle Management

This guide covers how to manage changes to your Snowflake infrastructure over time.

## The Change Workflow

```
Edit .tf files  →  terraform plan  →  Review  →  terraform apply  →  Verify
```

Every change follows this cycle. Terraform figures out the minimal set of API calls needed.

## Common Change Scenarios

### 1. Resize a Warehouse

Edit `envs/dev/warehouse.tf` and change the size:

```hcl
warehouse_size = "SMALL"    # was XSMALL
```

Or better, change it in `terraform.tfvars`:

```hcl
warehouse_size = "SMALL"
```

Then plan and apply:

```bash
terraform plan    # Shows: ~ snowflake_warehouse.main will be updated
terraform apply
```

### 2. Add a New Schema

Add a new resource block to `envs/dev/database.tf`:

```hcl
resource "snowflake_schema" "analytics" {
  name                = "${var.project_prefix}_ANALYTICS"
  database            = snowflake_database.main.name
  with_managed_access = false
}
```

### 3. Add a New Role with Grants

Add to `envs/dev/roles.tf`:

```hcl
resource "snowflake_account_role" "analyst_role" {
  provider = snowflake.useradmin
  name     = "${var.project_prefix}_ANALYST"
  comment  = "Read-only analyst role"
}
```

Then add corresponding grants in `envs/dev/grants.tf`.

### 4. Remove a Resource

Delete the resource block from the `.tf` file, then:

```bash
terraform plan    # Shows: - resource will be destroyed
terraform apply
```

### 5. Rename a Resource

Renaming requires an import/move to avoid destroy + recreate:

```bash
terraform state mv snowflake_schema.old_name snowflake_schema.new_name
```

### 6. Import Existing Snowflake Objects

If objects already exist in Snowflake and you want Terraform to manage them:

```bash
terraform import snowflake_database.main "TF_DEMO_DB"
terraform import snowflake_warehouse.main "TF_DEMO_WH"
```

## Git Workflow for Changes

### Feature Branch Workflow

```bash
# 1. Create a feature branch
git checkout -b feat/add-analytics-schema

# 2. Make your changes to .tf files

# 3. Validate
terraform plan

# 4. Commit
git add .
git commit -m "Add analytics schema"

# 5. Push and create PR
git push origin HEAD

# 6. After PR review and merge, apply from main
git checkout main
git pull
terraform apply
```

### Recommended Branch Strategy

| Branch | Purpose | Who applies |
|--------|---------|-------------|
| `main` | Production state | CI/CD pipeline |
| `feat/*` | New features | Developer (plan only) |
| `fix/*` | Bug fixes | Developer (plan only) |

## Adding a New Environment

To create a `staging` or `prod` environment:

```bash
cp -r envs/dev envs/prod
```

Edit `envs/prod/terraform.tfvars` with production values. Each environment has its own state file.

## Handling Drift

If someone makes manual changes in Snowflake that differ from Terraform state:

```bash
# Detect drift
terraform plan    # Will show differences

# Option A: Bring Snowflake back in line with Terraform
terraform apply

# Option B: Update Terraform to match Snowflake
# Edit .tf files to match, then:
terraform plan    # Should show "No changes"
```

## Terraform State Operations

```bash
# List all managed resources
terraform state list

# Show details of a specific resource
terraform state show snowflake_database.main

# Remove a resource from state (Terraform stops managing it, but doesn't delete it)
terraform state rm snowflake_database.main

# Move/rename a resource in state
terraform state mv snowflake_schema.old snowflake_schema.new

# Pull remote state locally (if using remote backend)
terraform state pull > backup.tfstate
```

## Troubleshooting

### "Resource already exists"
The object exists in Snowflake but not in Terraform state. Use `terraform import`.

### "Error: Provider produced inconsistent result"
Run `terraform refresh` to sync state, then retry.

### "Error acquiring the state lock"
Another Terraform process is running. Wait or force unlock:
```bash
terraform force-unlock <LOCK_ID>
```

### View detailed logs
```bash
TF_LOG=DEBUG terraform plan
```
