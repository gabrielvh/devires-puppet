# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "puppetlabs/centos-7.0-64-puppet"

  # VM hostname
  config.vm.hostname = "demo"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: "10.10.10.10"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder ".", "/etc/puppetlabs/code/environments/vagrant"
  config.vm.synced_folder "/tmp/software", "/software"
  #config.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
  
  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. View the documentation for the provider 
  # you are using for more information on available options.

  config.vm.provider :virtualbox do |vb|
    
    # Display the VirtualBox GUI when booting the machine
    #vb.gui = true
  
    # Customize the amount of memory on the VM:
    vb.memory = "1024"
    vb.name = "demo"
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  #config.vm.provision :shell, :path => "scripts/bootstrap.sh", :args => "'https://github.com/gibaholms/devires-puppet.git' master"
  config.vm.provision :shell, :path => "scripts/vagrant_provision.sh"
end
