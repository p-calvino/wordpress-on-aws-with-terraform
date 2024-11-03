#!/bin/bash
apt update -y
apt install -y apache2 php php-mysqli nfs-common 
systemctl start apache2
systemctl enable apache2
mkdir /var/www/html
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${EFS_ENDPOINT}:/ /var/www/html

if [ ! -f /var/www/html/wp-config.php ]; then
    curl -O https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    cp -r wordpress/* /var/www/html/
    chown -R www-data:www-data /var/www/html/
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    sed -i "s/database_name_here/wordpress/" /var/www/html/wp-config.php
    sed -i "s/username_here/admin/" /var/www/html/wp-config.php
    sed -i "s/password_here/${DB_PASSWORD}/" /var/www/html/wp-config.php
    sed -i "s/localhost/${DB_ENDPOINT}/" /var/www/html/wp-config.php
fi
