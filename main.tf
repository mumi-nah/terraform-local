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

resource "local_file" "db_password" {
  filename        = "${local.secrets_dir}/db_password.txt"
  content         = random_password.db_password.result
  file_permission = "0600"

  lifecycle {
    ignore_changes = [content]
  }
}

resource "local_file" "database_config" {
  filename = "${local.config_dir}/database.conf"
  content  = <<-EOT
    ${local.database_config_content}
    db_password_file = ${local_file.db_password.filename}
  EOT
}


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
