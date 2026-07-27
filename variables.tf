variable "project_root" {
  description = "Root folder where the generated project structure will be created"
  type        = string
  default     = "project"
}

variable "app_name" {
  description = "Name of the application being deployed"
  type        = string
}

variable "app_port" {
  description = "Port the application listens on"
  type        = number
  default     = 8080
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "db_name" {
  description = "Name of the application database"
  type        = string
}

variable "db_user" {
  description = "Username the application uses to connect to the database"
  type        = string
}

variable "db_password_length" {
  description = "Length of the randomly generated database password"
  type        = number
  default     = 16
}
