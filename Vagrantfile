# -*- mode: ruby -*-

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.provision "shell", path: "scripts/bootstrap.sh"
  config.vm.define "docker1" do |docker1|
    docker1.vm.hostname = "docker1"
    docker1.vm.network "private_network", ip: "192.168.100.100"
    docker1.vm.provider "virtualbox" do |vb|
      vb.name = "docker1"
      vb.cpus = "2"
      vb. memory = "4096"
    end
    docker1.vm.provision "shell", path: "scripts/docker-provision.sh"
  end
end
