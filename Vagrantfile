# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do | config |

  config.vm.box = "file://boxs/centos-7.6-x64.box"

  config.vm.network "public_network", ip: "192.168.2.110"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "centos7-vm"
    vb.memory = "2048"
    vb.cpus = 2
  end

end