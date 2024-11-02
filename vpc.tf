#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
#tfsec:ignore:aws-ec2-no-excessive-port-access
#tfsec:ignore:aws-ec2-no-public-ingress-acl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.14.0"

  name                           = local.vpc_name
  cidr                           = local.vpc_cidr
  azs                            = local.availability_zones
  default_security_group_ingress = []
  default_security_group_egress  = []
  #use_ipam_pool                  = false
  #ipv4_ipam_pool_id              = local.ipam_pool
  #ipv4_netmask_length            = 24

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

  public_inbound_acl_rules = [
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 2049,
      "protocol" : "tcp",
      "rule_action" : "deny",
      "rule_number" : 100,
      "to_port" : 2049
    },
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 80,
      "protocol" : "tcp",
      "rule_action" : "allow",
      "rule_number" : 101,
      "to_port" : 80
    },
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 443,
      "protocol" : "tcp",
      "rule_action" : "allow",
      "rule_number" : 102,
      "to_port" : 443
    },
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 1024,
      "protocol" : "tcp",
      "rule_action" : "allow",
      "rule_number" : 103,
      "to_port" : 65535
    }
  ]

  public_outbound_acl_rules = [
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 80,
      "protocol" : "tcp",
      "rule_action" : "allow",
      "rule_number" : 100,
      "to_port" : 80
    },
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 443,
      "protocol" : "tcp",
      "rule_action" : "allow",
      "rule_number" : 101,
      "to_port" : 443
    },
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 1024,
      "protocol" : "tcp",
      "rule_action" : "allow",
      "rule_number" : 102,
      "to_port" : 65535
    }
  ]

  private_inbound_acl_rules = [
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 80,
      "protocol" : "tcp",
      "rule_action" : "allow",
      "rule_number" : 100,
      "to_port" : 80
    }
  ]

  private_outbound_acl_rules = [
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 80,
      "protocol" : "tcp",
      "rule_action" : "allow",
      "rule_number" : 100,
      "to_port" : 80
    },
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 443,
      "protocol" : "tcp",
      "rule_action" : "allow",
      "rule_number" : 101,
      "to_port" : 443
    },
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 1024,
      "protocol" : "tcp",
      "rule_action" : "allow",
      "rule_number" : 102,
      "to_port" : 65535
    }
  ]

  database_inbound_acl_rules = [
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 3306,
      "protocol" : "tcp",
      "rule_action" : "allow",
      "rule_number" : 100,
      "to_port" : 3306
    }
  ]

  database_outbound_acl_rules = [
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 1024,
      "protocol" : "tcp",
      "rule_action" : "allow",
      "rule_number" : 100,
      "to_port" : 65535
    }
  ]

  enable_dns_hostnames = true
  enable_dns_support   = true

  #   default_network_acl_name    = local.default_network_acl_name
  #   default_route_table_name    = local.default_route_table_name
  #   database_subnet_group_name  = local.database_subnet_group_name
  #   default_security_group_name = local.default_security_group_name

  #enable_flow_log                                 = true
  #create_flow_log_cloudwatch_iam_role             = true
  #create_flow_log_cloudwatch_log_group            = true
  #flow_log_cloudwatch_log_group_kms_key_id        = data.aws_kms_key.default_cmk_key.arn
  #flow_log_cloudwatch_log_group_retention_in_days = 7

  #   vpc_tags = {
  #     "Name" = local.vpc_name
  #   }

  #   default_network_acl_tags = {
  #     "Name" = local.nacl_name
  #   }

  #   default_route_table_tags = {
  #     "Name" = local.default_route_table_name
  #   }

  #   database_subnet_group_tags = {
  #     "Tier" = "Database"
  #   }

  #   default_security_group_tags = {
  #     "Name" = local.default_security_group_name
  #   }

  #   igw_tags = {
  #     "Name" = local.igw_name
  #   }

  # nat_eip_tags = {
  #   "Name" = local.eip_name
  # }

  # nat_gateway_tags = {
  #   "Name" = local.nat_name
  # }

  #   public_route_table_tags = {
  #     "Name" = local.public_route_table_name
  #   }

  #   private_route_table_tags = {
  #     "Name" = local.private_route_table_name
  #   }

  #   tags = {
  #     "Environment" = local.current_environment
  #     "CostCenter"  = local.cc_app_tags.costcenter
  #     "Application" = local.cc_app_tags.application
  #   }
}

