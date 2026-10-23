# ---------------------------------------------------------------------------
# Data source: Amazon Linux 2023 AMI más reciente
# ---------------------------------------------------------------------------
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ---------------------------------------------------------------------------
# EC2 Instance: Moodle web server
# ---------------------------------------------------------------------------
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    delete_on_termination = true
  }

  user_data = templatefile("${path.module}/templates/user_data.sh.tpl", {
    db_host            = var.db_host
    db_name            = var.db_name
    db_username        = var.db_username
    db_password        = var.db_password
    moodle_admin_user  = var.moodle_admin_user
    moodle_admin_pass  = var.moodle_admin_pass
    moodle_admin_email = var.moodle_admin_email
  })

  tags = {
    Name = "${var.project_name}-web"
  }
}
