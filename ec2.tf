resource "aws_launch_template" "wordpress_lt" {
  name_prefix   = "wordpress-lt-"
  image_id      = "ami-0084a47cc718c111a"
  instance_type = "m5.large"

  iam_instance_profile {
    name = aws_iam_instance_profile.SSM_EC2_instance_profile.name
  }
  vpc_security_group_ids = [aws_security_group.app_security_group.id]
  user_data = base64encode("${templatefile("${path.module}/user_data.sh", {
    EFS_ENDPOINT = local.efs_endpoint
    DB_ENDPOINT  = local.db_endpoint
    DB_PASSWORD  = local.db_password
  })}")
}

resource "aws_iam_instance_profile" "SSM_EC2_instance_profile" {
  name = "SSM-EC2-instance-profile"
  role = aws_iam_role.SSM_for_EC2.name
}

