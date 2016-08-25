#!/usr/bin/env bash

PHP_TIMEZONE="$1"

# Install PHP
apt-get install -yqq php5 php5-dev php5-json php5-mysql php5-xdebug php5-apcu php5-curl php5-gd libapache2-mod-php5 php5-mcrypt

# Configure PHP
sed -i -r 's/memory_limit = 128M/memory_limit = 512M/' /etc/php5/apache2/php.ini
# PHP Error Reporting Config
sed -ir "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -ir "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

# PHP Date Timezone
sed -ir "s/;date.timezone =.*/date.timezone = ${PHP_TIMEZONE/\//\\/}/" /etc/php5/apache2/php.ini
sed -ie "s/;date.timezone =.*/date.timezone = ${PHP_TIMEZONE/\//\\/}/" /etc/php5/apache2/php.ini

# Install APC
# tee -a /etc/php5/mods-available/apc.ini << EOF
# ;;; APC Configuration - START
# apc.stat=1
# apc.num_files_hint=0
# apc.num_entries_hint=0
# apc.ttl=5400
# apc.user_ttl=5400
# apc.shm_segments=1
# ;; Set this to the same as `sysctl -a | grep -E "shmall"`
# apc.shm_size=268435456
# ;;; APC Configuration - END
# EOF

# Install Composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
tee -a /etc/bashrc << EOF

# Composer tools
export PATH=\$PATH:\$HOME/.composer/vendor/bin
EOF

service apache2 restart