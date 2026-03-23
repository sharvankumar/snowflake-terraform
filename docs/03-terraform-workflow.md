# 03 - Terraform Workflow

This document covers the core Terraform commands: **init**, **plan**, **apply**, and **destroy**.

## Initialize the Project

From the environment directory, download all required providers:

```bash
cd envs/dev
terraform init
```

This downloads the Snowflake and TLS providers into a local `.terraform/` directory.

> Run `terraform init -upgrade` anytime you change provider version constraints.

## Plan Changes

Generate an execution plan to preview what Terraform will do:

```bash
terraform plan
```

Terraform compares your `.tf` files (desired state) against the state file (current state) and shows:
- **+** Resources to create
- **~** Resources to modify
- **-** Resources to destroy

Always review the plan before applying.

## Apply Changes

Execute the planned changes:

```bash
terraform apply
```

Terraform shows the plan again and asks for confirmation. Type `yes` to proceed.

To skip the confirmation prompt (useful in CI/CD):

```bash
terraform apply -auto-approve
```

## Verify in Snowflake

After applying, log in to the Snowflake console and verify the objects were created:

```sql
SHOW DATABASES LIKE 'TF_DEMO%';
SHOW WAREHOUSES LIKE 'TF_DEMO%';
SHOW SCHEMAS IN DATABASE TF_DEMO_DB;
SHOW ROLES LIKE 'TF_DEMO%';
SHOW USERS LIKE 'TF_DEMO%';
```

## View Outputs

Terraform outputs are displayed after apply. To view them later:

```bash
terraform output
terraform output -json                    # JSON format
terraform output app_user_private_key     # Specific sensitive output
```

## Destroy Resources

To tear down all Terraform-managed resources:

```bash
terraform destroy
```

This removes **only** the resources Terraform created. It will not touch anything created manually.

## State Management

Terraform tracks resources in a state file (`terraform.tfstate`). Important rules:

1. **Never manually edit** the state file
2. **Never commit** state files to git (already in `.gitignore`)
3. **Back up** state files if using local backend
4. For teams, use a **remote backend** (S3, GCS, Terraform Cloud)

To inspect state:

```bash
terraform state list                       # List all managed resources
terraform state show snowflake_database.main  # Show details of one resource
```

## Next Step

Proceed to [04 - Lifecycle Management](./04-lifecycle-management.md).
