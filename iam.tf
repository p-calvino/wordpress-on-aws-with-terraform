resource "aws_iam_role" "SSM_for_EC2" {
  name = "SSM-EC2-Access-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "SSM_EC2_policy_attachment" {
  name       = "attach_SSM_EC2_policy"
  roles      = [aws_iam_role.SSM_for_EC2.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
