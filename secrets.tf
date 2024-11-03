data "aws_secretsmanager_random_password" "wordpress_db" {
  password_length    = 25
  exclude_characters = "/@\"\\'`"
}

resource "aws_secretsmanager_secret" "wordpress_db" {
  name                    = "DB-Wordpress-Password"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "wordpress_db" {
  secret_id     = aws_secretsmanager_secret.wordpress_db.id
  secret_string = data.aws_secretsmanager_random_password.wordpress_db.random_password
  lifecycle {
    ignore_changes = [secret_string]
  }
}
