locals {
  availability_zones = slice(data.aws_availability_zones.available.names, 0, var.number_of_azs)

  public_subnets   = [for i, az in local.availability_zones : cidrsubnet(module.subnets_cidrs.network_cidr_blocks["public"], 1, i)]
  app_subnets      = [for i, az in local.availability_zones : cidrsubnet(module.subnets_cidrs.network_cidr_blocks["app"], 1, i)]
  database_subnets = [for i, az in local.availability_zones : cidrsubnet(module.subnets_cidrs.network_cidr_blocks["database"], 1, i)]

  public_subnets_name   = [for az in local.availability_zones : "wordpress-public-subnet-${az}"]
  database_subnets_name = [for az in local.availability_zones : "wordpress-db-subnet-${az}"]
  app_subnet_name       = [for az in local.availability_zones : "wordpress-app-subnet-${az}"]

  current_account = data.aws_caller_identity.current.account_id
  current_region  = data.aws_region.current.name
  db_password     = aws_secretsmanager_secret_version.wordpress_db.secret_string
  efs_endpoint    = aws_efs_file_system.wordpress_efs.dns_name
  db_endpoint     = aws_db_instance.wordpress_db.address

  vpc_name      = "vpc-wordpress"
  project_name  = "wordpress"
  alb_name      = "${local.project_name}-alb"
  tg_name       = "${local.project_name}-tg"
  listener_name = "${local.project_name}-listener"
  lt_name       = "${local.project_name}-lt"
  asg_name      = "${local.project_name}-asg"
  db_name       = "${local.project_name}-db"
  web_sg_name   = "${local.project_name}-web-sg"
  app_sg_name   = "${local.project_name}-app-sg"
  db_sg_name    = "${local.project_name}-db-sg"
  efs_name      = "${local.project_name}-efs"
  environment   = "dev"
}
