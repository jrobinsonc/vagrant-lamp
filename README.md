# Vagrant

An Ubuntu based Vagrantfile with options to include MySQL, PHP, and more.

## Requirements

1. [VirtualBox](https://www.virtualbox.org/)
2. [Vagrant](https://www.vagrantup.com/)
3. The following Vagrant plugins:
    * [VirtualBox Guest Additions Updater](https://github.com/dotless-de/vagrant-vbguest): `vagrant plugin install vagrant-vbguest`
    * [Hosts Provisioner](https://github.com/mdkholy/vagrant-hosts-provisioner): `vagrant plugin install vagrant-hosts-provisioner`

## Usage

Download a copy of this repo, and place it in the same directory as your code.

Edit the file `config.yml`.

Finally, run a `vagrant up` to start your Vagrant box.