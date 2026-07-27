# -----------------------------------------------------------------------
# Random database password
# -----------------------------------------------------------------------
resource "random_password" "db_password" {
  length           = var.db_password_length
  special          = true
  override_special = "!@#%&"
}

# -----------------------------------------------------------------------
# config/app.conf
# -----------------------------------------------------------------------
resource "local_file" "app_config" {
  filename = "${local.config_dir}/app.conf"
  content  = local.app_config_content

  # Lifecycle rule requirement: replace the new file before deleting
  # the old one, so there's never a moment with no app.conf on disk.
  lifecycle {
    create_before_destroy = true
  }
}

# -----------------------------------------------------------------------
# secrets/db_password.txt
# Implicit dependency: referencing random_password.db_password.result
# tells Terraform this file must be created AFTER the password exists,
# with no depends_on needed.
# -----------------------------------------------------------------------
resource "local_file" "db_password" {
  filename        = "${local.secrets_dir}/db_password.txt"
  content         = random_password.db_password.result
  file_permission = "0600"

  # Lifecycle rule requirement: once a password file exists, don't
  # rewrite it just because the random value would differ on a replan -
  # avoids silently rotating credentials on every apply.
  lifecycle {
    ignore_changes = [content]
  }
}

# -----------------------------------------------------------------------
# config/database.conf
# Implicit dependency: references local_file.db_password.filename
# (a resource attribute), so Terraform orders this after db_password.
# -----------------------------------------------------------------------
resource "local_file" "database_config" {
  filename = "${local.config_dir}/database.conf"
  content  = <<-EOT
    ${local.database_config_content}
    db_password_file = ${local_file.db_password.filename}
  EOT
}

# -----------------------------------------------------------------------
# reports/deployment_report.txt
# Explicit dependency: content below is built only from variables/locals,
# so Terraform has no attribute reference to infer ordering from.
# depends_on forces this to run after the other three files exist.
# -----------------------------------------------------------------------
resource "local_file" "deployment_report" {
  filename = "${local.reports_dir}/deployment_report.txt"
  content  = <<-EOT
    Deployment Report
    ==================
    Application : ${var.app_name}
    Environment : ${var.environment}
    Generated   : ${local.generated_at}

    Files created:
      - ${local.config_dir}/app.conf
      - ${local.config_dir}/database.conf
      - ${local.secrets_dir}/db_password.txt
  EOT

  depends_on = [
    local_file.app_config,
    local_file.database_config,
    local_file.db_password,
  ]
}
