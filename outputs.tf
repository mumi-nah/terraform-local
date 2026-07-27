output "app_config_path" {
  description = "Path to the generated app config file"
  value       = local_file.app_config.filename
}

output "database_config_path" {
  description = "Path to the generated database config file"
  value       = local_file.database_config.filename
}

output "db_password_path" {
  description = "Path to the generated DB password file"
  value       = local_file.db_password.filename
}

output "deployment_report_path" {
  description = "Path to the generated deployment report"
  value       = local_file.deployment_report.filename
}

output "generated_db_password" {
  description = "The randomly generated database password"
  value       = random_password.db_password.result
  sensitive   = true
}
