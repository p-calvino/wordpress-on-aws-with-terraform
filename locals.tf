locals {
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = slice(data.aws_availability_zones.available.names, 0, var.number_of_azs)

  public_subnets   = [for i, az in local.availability_zones : cidrsubnet(module.subnets_cidrs.network_cidr_blocks["public"], 1, i)]
  app_subnets      = [for i, az in local.availability_zones : cidrsubnet(module.subnets_cidrs.network_cidr_blocks["app"], 1, i)]
  database_subnets = [for i, az in local.availability_zones : cidrsubnet(module.subnets_cidrs.network_cidr_blocks["database"], 1, i)]

  public_subnets_name   = [for i, az in local.availability_zones : "subnet-wordpress-public-${az}"]
  database_subnets_name = [for i, az in local.availability_zones : "subnet-wordpress-db-${az}"]
  app_subnet_name       = [for i, az in local.availability_zones : "subnet-wordpress-app-${az}"]
  current_account       = data.aws_caller_identity.current.account_id
  current_region        = data.aws_region.current.name
  db_password           = aws_secretsmanager_secret_version.wordpress_db.secret_string
  efs_endpoint          = aws_efs_file_system.wordpress_efs.dns_name
  db_endpoint           = aws_db_instance.wordpress_db.address
  current_environment   = "dev"
  vpc_name              = "vpc-wordpress"

  #   resource_suffix             = join("-", [local.current_region, local.env_suffix, local.account_name])
  #   default_network_acl_name    = "nacl-${local.resource_suffix}"
  #   default_route_table_name    = "rtb-default-${local.resource_suffix}"
  #   public_route_table_name     = "rtb-public-${local.resource_suffix}"
  #   private_route_table_name    = "rtb-private-${local.resource_suffix}"
  #   tgw_route_table_name        = "rtb-tgw-${local.resource_suffix}"
  #   database_subnet_group_name  = "netgroup-${local.resource_suffix}"
  #   default_security_group_name = "sg-${local.resource_suffix}"
  #   nacl_name                   = "nacl-${local.resource_suffix}"
  #   igw_name                    = "igw-${local.resource_suffix}"
  #   eip_name                    = "eip-${local.resource_suffix}"
  #nat_name                    = "nat-${local.short_azs[0]}-${local.env_suffix}-${local.account_name}"
  #   private_hosted_zone = "group3.aws.capci-lz.private"
  #   sg_resolver_name    = "resolver-sg-${local.resource_suffix}"
  # inbound_resolver_name       = "inbound-resolver-${local.resource_suffix}"
  # outbound_resolver_name      = "outbound-resolver-${local.resource_suffix}"
  # resolver_rule_name          = "resolver-rule-${local.resource_suffix}"

  # endpoints = {
  #   inbound = {
  #     direction   = "INBOUND",
  #     name        = local.inbound_resolver_name
  #     application = "Inbound Resolver"
  #   },
  #   outbound = {
  #     direction   = "OUTBOUND",
  #     name        = local.outbound_resolver_name
  #     application = "Outbound Resolver"
  #   }
  # }

  #   bucket_name         = "s3-ec-1-prod-vpc-flow-log-314812758562"
  #   bucket_name_parquet = "s3-ec-1-prod-vpc-flow-log-parquet-314812758562"
}
