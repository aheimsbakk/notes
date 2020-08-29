# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# Used for testing scripts
#

Vagrant.configure("2") do |config|
  config.vm.box = "debian/buster64"

  config.vm.synced_folder ".", "/vagrant", disabled: false, type: "sshfs"

  config.vm.provider "libvirt" do |l|
    l.cpus = 1
    l.memory = "1024"
    l.qemu_use_session = false
  end

  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
