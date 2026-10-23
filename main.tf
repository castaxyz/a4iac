# ---------------------------------------------------------------------------
# Provider
# ---------------------------------------------------------------------------
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = var.project_name
      ManagedBy = "terraform"
    }
  }
}

# ---------------------------------------------------------------------------
# Module: networking
# ---------------------------------------------------------------------------
module "networking" {
  source = "./modules/networking"

  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
}

# ---------------------------------------------------------------------------
# Module: database
# ---------------------------------------------------------------------------
module "database" {
  source = "./modules/database"

  project_name      = var.project_name
  subnet_ids        = module.networking.public_subnet_ids
  security_group_id = module.networking.db_security_group_id
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
}

# ---------------------------------------------------------------------------
# Module: compute
# ---------------------------------------------------------------------------
module "compute" {
  source = "./modules/compute"

  project_name       = var.project_name
  subnet_id          = module.networking.public_subnet_id
  security_group_id  = module.networking.web_security_group_id
  instance_type      = var.instance_type
  root_volume_size   = var.root_volume_size
  db_host            = module.database.address
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  moodle_admin_user  = var.moodle_admin_user
  moodle_admin_pass  = var.moodle_admin_pass
  moodle_admin_email = var.moodle_admin_email
}
