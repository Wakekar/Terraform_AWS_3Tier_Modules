resource "aws_db_subnet_group" "main" {
  name       = "${var.name}-db-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-db-subnet-group"
      Tier = "Database"
    }
  )
}

resource "aws_db_instance" "main" {
  identifier = "${var.name}-db"

  engine         = var.engine
  engine_version = var.engine_version

  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = var.db_port

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = var.security_group_ids

  multi_az                = var.multi_az
  publicly_accessible     = false
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = var.skip_final_snapshot
  copy_tags_to_snapshot   = true
  backup_retention_period = var.backup_retention_period

  backup_window      = "18:00-19:00"
  maintenance_window = "sun:19:00-sun:20:00"

  auto_minor_version_upgrade = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-db"
      Tier = "Database"
    }
  )
}
