variable "project_name" {
  description = "Name of the project, used as a prefix for resource naming."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group."
  type        = list(string)
}

variable "security_group_id" {
  description = "ID of the security group to associate with the DB instance."
  type        = string
}

variable "db_name" {
  description = "Name of the initial database to create."
  type        = string
  default     = "moodle"
}

variable "db_username" {
  description = "Master username for the DB instance."
  type        = string
  default     = "moodleuser"
}

variable "db_password" {
  description = "Master password for the DB instance."
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage size in GiB."
  type        = number
  default     = 20
}
