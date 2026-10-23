variable "aws_region" {
  description = "AWS region where all resources will be deployed."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project, used as a prefix for resource naming and tagging."
  type        = string
  default     = "a4iac-moodle"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for the public subnets (one per AZ)."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type for the Moodle web server."
  type        = string
  default     = "t3.small"
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GiB."
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Name of the Moodle database."
  type        = string
  default     = "moodle"
}

variable "db_username" {
  description = "Master username for the RDS instance."
  type        = string
  default     = "moodleuser"
}

variable "db_password" {
  description = "Master password for the RDS instance. Must be provided at runtime."
  type        = string
  sensitive   = true
}

variable "moodle_admin_user" {
  description = "Moodle administrator username."
  type        = string
  default     = "admin"
}

variable "moodle_admin_pass" {
  description = "Moodle administrator password."
  type        = string
  sensitive   = true
  default     = "Admin_Moodle2026!"
}

variable "moodle_admin_email" {
  description = "Moodle administrator email address."
  type        = string
  default     = "admin@example.com"
}
