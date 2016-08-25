#!/usr/bin/env bash

apt-get autoremove -yqq
apt-get clean -yqq

# Fix any permissions borked as a result of installing things as root
chown -R vagrant:vagrant /home/vagrant/
chown -R vagrant:vagrant /var/www/
