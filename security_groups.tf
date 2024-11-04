resource "aws_security_group" "web_sg" {
  name        = local.web_sg_name
  description = "Security group for public access to Wordpress"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP access from anywhere"
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = module.vpc.private_subnets_cidr_blocks
    description = "Allow HTTP traffic to App Subnet"
  }

  tags = {
    Name        = local.web_sg_name
    Environment = local.environment
  }
}

resource "aws_security_group" "app_sg" {
  name        = local.app_sg_name
  description = "Security group for Wordpress application"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
    description     = "Allow HTTP traffic from Web security group"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = local.app_sg_name
    Environment = local.environment
  }
}

resource "aws_security_group" "db_sg" {
  name        = local.db_sg_name
  description = "Security group for Wordpress database"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
    description     = "Allow MySQL access from App security group"
  }

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
    description     = "Allow NFS traffic from App security group"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = local.db_sg_name
    Environment = local.environment
  }
}
