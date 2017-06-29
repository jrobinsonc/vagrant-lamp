#!/usr/bin/env bash

ROOT_PASSWORD=$2
# DB_USER=$1
# DB_PASSWORD=$2

debconf-set-selections <<< "mysql-server mysql-server/root_password password $ROOT_PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $ROOT_PASSWORD"

apt-get install -yqq mysql-server mysql-client

#mysqladmin -u root password newpass

# Enable remote access to MySQL
#sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

#sudo service mysql restart

# tee -a /etc/bashrc << EOF

# # Restart MySQL if not running
# IS_MYSQL_RUNNING=\$( ps aux | grep mysqld | grep -v grep | wc -l )
# if [ "\$PS1" ] && [ "\$IS_MYSQL_RUNNING" = "0" ]; then
#     echo "Starting MySQL"
#     sudo rm -f /var/run/mysqld/mysqld.sock
#     sudo /etc/init.d/mysql restart
# fi
# EOF
