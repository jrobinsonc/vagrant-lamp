#!/usr/bin/env bash

MAILTRAP_USER=$1
MAILTRAP_PASSWORD=$2

# Install postfix
debconf-set-selections <<EOF
postfix postfix/main_mailer_type string "Internet Site"
postfix postfix/mailname string mailtrap.io
EOF
apt-get install -yqq postfix mailutils

# Install the main postfix config
postconf relayhost="[mailtrap.io]:2525"
postconf smtp_sasl_auth_enable="yes"
postconf smtp_sasl_mechanism_filter="plain"
postconf smtp_sasl_security_options="noanonymous"
postconf smtp_sasl_password_maps="hash:/etc/postfix/sasl_passwd"

tee /etc/postfix/sasl_passwd << EOF
mailtrap.io $MAILTRAP_USER:$MAILTRAP_PASSWORD
EOF

/usr/sbin/postmap /etc/postfix/sasl_passwd
/etc/init.d/postfix restart