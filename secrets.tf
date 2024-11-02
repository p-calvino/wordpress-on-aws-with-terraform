data "aws_secretsmanager_random_password" "wordpress_db" {
  password_length = 25
}

resource "aws_secretsmanager_secret" "wordpress_db" {
  name = "Wordpress-DB-Password"
}

resource "aws_secretsmanager_secret_version" "wordpress_db" {
  secret_id     = aws_secretsmanager_secret.wordpress_db.id
  secret_string = <<EOF
   {
    "password": "${data.aws_secretsmanager_random_password.wordpress_db.random_password}"
   }
EOF
}
