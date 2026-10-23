# ---------------------------------------------------------------------------
# DB Subnet Group
# ---------------------------------------------------------------------------
resource "aws_db_subnet_group" "this" {
  name        = "${var.project_name}-db-subnet-group"
  description = "Subnet group for ${var.project_name} RDS instance"
  subnet_ids  = var.subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# ---------------------------------------------------------------------------
# RDS Instance (MariaDB)
# ---------------------------------------------------------------------------
resource "aws_db_instance" "this" {
  identifier        = "${var.project_name}-db"
  allocated_storage = var.allocated_storage
  storage_type      = "gp3"

  engine         = "mariadb"
  engine_version = "10.11"
  instance_class = var.instance_class

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.security_group_id]

  publicly_accessible = false
  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name = "${var.project_name}-db"
  }
}
