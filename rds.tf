resource "aws_db_instance" "wordpress_db" {
  allocated_storage      = 20
  max_allocated_storage  = 100
  identifier             = "wordpress-db"
  db_name                = "wordpress"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_type
  username               = var.db_username
  password               = local.db_password
  parameter_group_name   = "default.mysql8.0"
  kms_key_id             = aws_kms_key.rds_kms_key.arn
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  storage_encrypted      = true
  multi_az               = true
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  tags = {
    Name = local.db_name
  }
}
