resource "aws_launch_template" "wordpress_lt" {
  name_prefix   = "wordpress-lt-"
  image_id      = "ami-0084a47cc718c111a"
  instance_type = "t2.medium"
  key_name      = "test"
  iam_instance_profile {
    name = aws_iam_instance_profile.SSM_EC2_instance_profile.name
  }
  vpc_security_group_ids = [aws_security_group.app_security_group.id]
  user_data = base64encode(<<-EOF
                          #!/bin/bash
                          apt update -y
                          apt install -y apache2 php php-mysqli nfs-common 
                          systemctl start apache2
                          systemctl enable apache2
                          mkdir /var/www/html
                          mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.wordpress_efs.dns_name}:/ /var/www/html
                          if [ ! -f /var/www/html/wp-config.php ]; then
                              curl -O https://wordpress.org/latest.tar.gz
                              tar -xzf latest.tar.gz
                              cp -r wordpress/* /var/www/html/
                              chown -R www-data:www-data /var/www/html/
                              cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
                              sed -i "s/database_name_here/wordpress/" /var/www/html/wp-config.php
                              sed -i "s/username_here/admin/" /var/www/html/wp-config.php
                              sed -i "s/password_here/admin1243/" /var/www/html/wp-config.php
                              sed -i "s/localhost/wordpress-db.cx6em35d27ke.eu-central-1.rds.amazonaws.com/" /var/www/html/wp-config.php
                          fi
                          EOF
  )
}

# resource "aws_iam_instance_profile" "efs_instance_profile" {
#   name = "efs-instance-profile"
#   role = aws_iam_role.efs_access_role.name
# }

resource "aws_iam_instance_profile" "SSM_EC2_instance_profile" {
  name = "SSM-EC2-instance-profile"
  role = aws_iam_role.SSM_for_EC2.name
}
