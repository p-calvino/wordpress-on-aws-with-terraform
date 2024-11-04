resource "aws_efs_file_system" "wordpress_efs" {
  creation_token = "wordpress-efs"
  encrypted      = true
  kms_key_id     = aws_kms_key.efs_kms_key.arn

  tags = {
    Name = local.efs_name
  }
}

resource "aws_efs_mount_target" "wordpress_efs_az_target" {
  count           = length(module.vpc.database_subnets)
  file_system_id  = aws_efs_file_system.wordpress_efs.id
  subnet_id       = element(module.vpc.database_subnets, count.index)
  security_groups = [aws_security_group.db_sg.id]
}

