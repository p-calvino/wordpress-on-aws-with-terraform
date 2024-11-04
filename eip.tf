resource "aws_eip" "nat" {
  count  = var.number_of_azs
  domain = "vpc"

  tags = {
    Name = "wordpress-eip-${local.availability_zones[count.index]}"
  }
}
