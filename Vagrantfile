# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  $replicas = 3

  config.vm.box_check_update = false

  #https://stackoverflow.com/questions/19490652/how-to-sync-time-on-host-wake-up-within-virtualbox
  config.vm.provider 'virtualbox' do |vb|
   vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 1000 ]
  end

  (1..$replicas).each do |i|
    config.vm.define "node-#{i}" do |node|

      node.vm.box = "file://boxs/centos-docker-7.6-x64.box"
      node.vm.hostname = "node-#{i}"
      node.vm.network :public_network, ip: "192.168.2.20#{i}"

      node.vm.provider "virtualbox" do |vb|
        vb.name = "node#{i}-vm"
        vb.memory = "5120"
        vb.cpus = 2
      end

    end
  end

end