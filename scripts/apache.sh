#!/usr/bin/env bash

APACHE_HOSTNAME="$1"
APACHE_DOCUMENT_ROOT="$2"

apt-get install -yqq apache2

# Configure Apache
rm -f /etc/apache2/sites-available/000-default.conf
rm -f /etc/apache2/sites-enabled/000-default.conf

tee /etc/apache2/sites-enabled/000-default.conf << EOF
<VirtualHost *:80>
    DocumentRoot $APACHE_DOCUMENT_ROOT
    ServerName $APACHE_HOSTNAME

    # Allow Apache to properly read files from the synced folders
    EnableSendfile off

    <Directory "$APACHE_DOCUMENT_ROOT">
        Options Indexes FollowSymLinks MultiViews
        
        # Enable .htaccess support
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>

EOF

# Make apache run as vagrant
sed -ir 's/export APACHE_RUN_USER=.*/export APACHE_RUN_USER=vagrant/' /etc/apache2/envvars
sed -ir 's/export APACHE_RUN_GROUP=.*/export APACHE_RUN_GROUP=vagrant/' /etc/apache2/envvars

# Enable common modules
a2enmod rewrite headers expires vhost_alias

# Allow all users to tail the logs
chmod 777 /var/log/apache2/

chown -R vagrant:vagrant /var/lock/apache2

service apache2 restart

# Restart Apache if not running
# tee -a /etc/bashrc << EOF

# IS_APACHE_RUNNING=\$( ps aux | grep apache2 | grep -v grep | wc -l )
# if [ "\$PS1" ] && [ "\$IS_APACHE_RUNNING" = "0" ]; then
#     echo "Starting Apache"
#     sudo service apache2 restart
# fi
# EOF