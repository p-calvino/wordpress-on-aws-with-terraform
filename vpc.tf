module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.14.0"

  name             = local.vpc_name
  cidr             = var.vpc_cidr
  azs              = local.availability_zones
  public_subnets   = local.public_subnets
  private_subnets  = local.app_subnets
  database_subnets = local.database_subnets

  public_subnet_names   = local.public_subnets_name
  private_subnet_names  = local.app_subnet_name
  database_subnet_names = local.database_subnets_name
  enable_nat_gateway    = true
  single_nat_gateway    = false
  reuse_nat_ips         = true
  external_nat_ip_ids   = aws_eip.nat[*].id

  enable_dns_hostnames = true
  enable_dns_support   = true
}

