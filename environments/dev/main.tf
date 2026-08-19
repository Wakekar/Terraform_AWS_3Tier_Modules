terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

module "vpc" {
  source = "../../modules/vpc"

  name = var.name

  vpc_cidr = var.vpc_cidr

  availability_zones    = var.availability_zones
  public_subnet_cidrs   = var.public_subnet_cidrs
  app_subnet_cidrs      = var.app_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs

  tags = var.tags
}

module "nat" {
  source = "../../modules/nat"

  name = var.name

  public_subnet_id        = module.vpc.public_subnet_ids[0]
  private_route_table_ids = module.vpc.app_route_table_ids

  tags = var.tags
}

module "security_groups" {
  source = "../../modules/security-groups"

  name   = var.name
  vpc_id = module.vpc.vpc_id

  tags = var.tags
}

module "iam" {
  source = "../../modules/iam"

  name = var.name

  tags = var.tags
}

module "alb" {
  source = "../../modules/alb"

  name = var.name

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids

  security_group_id = module.security_groups.alb_security_group_id

  target_port       = 80
  health_check_path = "/"

  tags = var.tags
}

module "compute" {
  source = "../../modules/compute"

  name        = var.name
  environment = "dev"

  ami_id        = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  app_subnet_ids = module.vpc.app_subnet_ids

  security_group_id = module.security_groups.app_security_group_id

  instance_profile_name = module.iam.instance_profile_name

  target_group_arn = module.alb.target_group_arn

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  user_data = <<-EOF
    #!/bin/bash
    set -e

    dnf update -y
    dnf install -y nginx

    systemctl enable nginx
    systemctl start nginx

    cat > /usr/share/nginx/html/index.html <<HTML
    <html>
      <head>
        <title>Three Tier Application</title>
      </head>
      <body>
        <h1>Three Tier Application</h1>
        <h2>Environment: DEV</h2>
        <p>Application Server: $(hostname)</p>
      </body>
    </html>
    HTML
  EOF

  tags = var.tags
}

module "database" {
  source = "../../modules/database"

  name = var.name

  database_subnet_ids = module.vpc.database_subnet_ids

  security_group_ids = [
    module.security_groups.database_security_group_id
  ]

  engine                = var.db_engine
  engine_version        = var.db_engine_version
  instance_class        = var.db_instance_class
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  db_port     = var.db_port

  multi_az                = var.db_multi_az
  deletion_protection     = var.db_deletion_protection
  skip_final_snapshot     = var.db_skip_final_snapshot
  backup_retention_period = var.db_backup_retention_period

  tags = var.tags
}
