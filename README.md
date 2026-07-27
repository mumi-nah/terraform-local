# Terraform Local Infrastructure Assignment

Generates a local project structure (config files, a secret, and a deployment
report) purely with Terraform, using the `local` and `random` providers.
No cloud account required.

## Structure produced after `terraform apply`

```
project/
├── config/
│   ├── app.conf
│   └── database.conf
├── secrets/
│   └── db_password.txt
└── reports/
    └── deployment_report.txt
```

## Concepts demonstrated

| Requirement              | Where |
|---------------------------|-------|
| Input variables            | `variables.tf` |
| tfvars file                 | `terraform.tfvars` |
| Variable referencing        | `var.app_name`, `var.db_name`, etc. throughout |
| Resource attributes         | `random_password.db_password.result`, `local_file.db_password.filename` |
| Implicit dependencies       | `db_password.txt` → `random_password`; `database.conf` → `db_password.txt` |
| Explicit dependency (`depends_on`) | `local_file.deployment_report` |
| Multiple providers          | `local` + `random` (see `providers.tf`) |
| Locals                      | `locals.tf` |
| Lifecycle rules             | `create_before_destroy` on `app_config`, `ignore_changes` on `db_password` |
| Data sources                | `data "local_file" "app_template"` in `data.tf` |

## Running it

```bash
terraform init
terraform plan
terraform apply
```

Confirm with `yes` when prompted. Take your `terraform apply` screenshot
after it finishes successfully.

## Cleaning up

```bash
terraform destroy
```

## Notes

- `terraform.tfvars` is auto-loaded by Terraform — no `-var-file` flag needed.
- The `random_password` value is marked `sensitive` in `outputs.tf`, so it
  won't print in plain text during `apply`; check `secrets/db_password.txt`
  or run `terraform output -raw generated_db_password` to see it.
- Don't commit real secrets to GitHub in a real project — this assignment
  writes a password to disk on purpose since that's the deliverable, but
  add `project/` and `*.tfstate*` to `.gitignore` before pushing.
