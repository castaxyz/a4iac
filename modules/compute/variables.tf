variable "project_name" {
  description = "Name of the project, used as a prefix for resource naming."
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where the EC2 instance will be launched."
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group to associate with the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.small"
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GiB."
  type        = number
  default     = 20
}

variable "db_host" {
  description = "Hostname or endpoint of the database server."
  type        = string
}

variable "db_name" {
  description = "Name of the Moodle database."
  type        = string
}

variable "db_username" {
  description = "Username for the Moodle database."
  type        = string
}

variable "db_password" {
  description = "Password for the Moodle database."
  type        = string
  sensitive   = true
}

variable "moodle_admin_user" {
  description = "Moodle admin username."
  type        = string
  default     = "admin"
}

variable "moodle_admin_pass" {
  description = "Moodle admin password."
  type        = string
  sensitive   = true
  default     = "Admin_Moodle2026!"
}

variable "moodle_admin_email" {
  description = "Moodle admin email address."
  type        = string
  default     = "admin@example.com"
}
