module "subnets_cidrs" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  base_cidr_block = local.vpc_cidr
  networks = [
    {
      name     = "public"
      new_bits = 7
    },
    {
      name     = "app"
      new_bits = 7
    },
    {
      name     = "database"
      new_bits = 7
    }
  ]
}
