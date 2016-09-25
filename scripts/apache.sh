#!/usr/bin/env bash

APACHE_HOSTNAME="$1"
APACHE_DOCUMENT_ROOT="$2"

apt-get install -yqq apache2

# Configure Apache
tee /etc/apache2/sites-available/000-default.conf << EOF
<VirtualHost *:80>
    DocumentRoot $APACHE_DOCUMENT_ROOT
    ServerName $APACHE_HOSTNAME
    ServerAdmin webmaster@localhost

    # Allow Apache to properly read files from the synced folders
    EnableSendfile off

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined

    <Directory "$APACHE_DOCUMENT_ROOT">
        Options Indexes FollowSymLinks MultiViews
        
        # Enable .htaccess support
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>

EOF

# Make apache run as vagrant
sed -i -r 's/export APACHE_RUN_USER=.*/export APACHE_RUN_USER=vagrant/' /etc/apache2/envvars
sed -i -r 's/export APACHE_RUN_GROUP=.*/export APACHE_RUN_GROUP=vagrant/' /etc/apache2/envvars

# Enable common modules
a2enmod rewrite headers expires vhost_alias

chown -R vagrant:vagrant /var/log/apache2
chown -R vagrant:vagrant /var/lock/apache2
chown -R vagrant:vagrant $APACHE_DOCUMENT_ROOT

service apache2 restart
