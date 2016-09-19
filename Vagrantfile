require 'yaml'

if !File.exists? ("config.yml")
  abort "\nERROR: config.yml does not exist.\n\n"
end

settings = YAML.load_file 'config.yml'

VAGRANTFILE_API_VERSION = 2

apache_document_root = "/var/www/html"

Vagrant.require_version ">= 1.8.1"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"

  # Host name
  config.vm.hostname = settings['hostname']

  # VirtualBox Guest Additions.
  config.vbguest.iso_path = "http://download.virtualbox.org/virtualbox/%{version}/VBoxGuestAdditions_%{version}.iso"
  config.vbguest.auto_update = true

  # config.vm.network "forwarded_port", guest: 80, host: 80
  # config.vm.network "forwarded_port", guest: 3306, host: 3306
  # config.vm.network "forwarded_port", guest: 443, host: 443

  config.vm.network "private_network", ip: settings['ip']

  # Synced folders.
  config.vm.synced_folder "../", apache_document_root, 
    :mount_options => ['dmode=755', 'fmode=644']

  config.vm.provider "virtualbox" do |vb|
    # Enable symlinks in synced folders.
    vb.customize ['setextradata', :id, 'VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root', '1' ]

    vb.memory = settings['vm']['memory']
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", settings['vm']['cpu']]
    vb.name = settings['hostname']
  end

  # Copy over your SSH keys to the VM.
  config.vm.provision "file", source: "~/.ssh/id_rsa", destination: "/home/vagrant/.ssh/id_rsa"
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"
  
  # Copy GIT config to the VM.
  config.vm.provision "file", source: "~/.gitconfig", destination: "/home/vagrant/.gitconfig"

  # Setup the hosts
  # This requires the hosts provisioner plugin to be installed: vagrant plugin install vagrant-hosts-provisioner
  config.vm.provision :hostsupdate, run: 'always' do |host|
    host.hostname = "#{settings['hostname']}.dev"
    host.manage_guest = true
    host.manage_host = true
    host.aliases = []
  end

  config.vm.provision :shell, path: "scripts/bootstrap.sh", :args => [settings['timezone']]
  config.vm.provision :shell, path: "scripts/apache.sh", :args => [settings['hostname'], apache_document_root]
  config.vm.provision :shell, path: "scripts/mysql.sh", :args => [settings['mysql']['user'], settings['mysql']['pass']]
  config.vm.provision :shell, path: "scripts/php.sh", :args => [settings['timezone']]
  config.vm.provision :shell, path: "scripts/ngrok.sh", :args => [settings['ngrok']['authtoken']]
  config.vm.provision :shell, path: "scripts/git.sh", :args => []
  config.vm.provision :shell, path: "scripts/mailtrap.sh", :args => [settings['mailtrap']['user'], settings['mailtrap']['pass']]
  config.vm.provision :shell, path: "scripts/cleanup.sh", :args => []

  # config.vm.post_up_message = 'All done!'

end
