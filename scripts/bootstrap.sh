#!/usr/bin/env bash

TIMEZONE="$1"

chmod 0700 /home/vagrant/.ssh/
chmod 0600 /home/vagrant/.ssh/id_rsa

ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime

export LANG=C.UTF-8

tee -a /etc/bashrc << EOF
export LANG=C.UTF-8

# Development environment customizations
alias ll='ls -al --color=auto'
EOF

apt-get update -yqq
