# resource "aws_rds_cluster" "wordpress_cluster" {
#   cluster_identifier     = "wordpress-cluster"
#   engine                 = "aurora-mysql"
#   engine_version         = "5.7.mysql_aurora.2.11.2"
#   availability_zones     = module.vpc.azs
#   database_name          = "wordpress_database"
#   master_username        = "admin"
#   master_password        = "admin1232"
#   vpc_security_group_ids = [aws_security_group.db_security_group.id]
#   db_subnet_group_name   = module.vpc.database_subnet_group_name
#   kms_key_id             = aws_kms_key.rds_kms.arn
#   storage_encrypted      = true
#   deletion_protection    = false
#   skip_final_snapshot    = true
# }

# resource "aws_rds_cluster_instance" "wordpress_cluster_instance" {
#   count               = 1
#   cluster_identifier  = aws_rds_cluster.wordpress_cluster.id
#   apply_immediately   = true
#   identifier          = "wordpress-cluster-instance-${count.index}"
#   instance_class      = "db.t3.medium"
#   engine              = "aurora-mysql"
#   publicly_accessible = true
# }

resource "aws_db_instance" "wordpress_db" {
  allocated_storage      = 10
  max_allocated_storage  = 100
  identifier             = "wordpress-db"
  db_name                = "wordpress"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.medium"
  username               = "admin"
  password               = "admin1243"
  parameter_group_name   = "default.mysql8.0"
  kms_key_id             = aws_kms_key.rds_kms_key.arn
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  storage_encrypted      = true
  multi_az               = true
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
}
