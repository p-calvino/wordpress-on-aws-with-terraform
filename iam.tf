# resource "aws_iam_role" "efs_access_role" {
#   name = "efs-access-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# resource "aws_iam_policy" "efs_access_policy" {
#   name = "efs-access-policy"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "elasticfilesystem:ClientMount",
#           "elasticfilesystem:ClientWrite",
#           "elasticfilesystem:DescribeMountTargets"
#         ]
#         Resource = aws_efs_file_system.wordpress_efs.arn
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "efs_access_attachment" {
#   role       = aws_iam_role.efs_access_role.name
#   policy_arn = aws_iam_policy.efs_access_policy.arn
# }

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
