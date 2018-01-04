# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.hostname = "qor-example"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "2048"
    vb.cpus = 3
    vb.customize ["modifyvm", :id, "--name", "qor-example"]
  end
  config.vm.provision "shell", inline: "mkdir -p -m 777 /qor", privileged: true
  # provisioning environment settings
  config.vm.provision "file", source: "qor_config/bootstrap.sh", destination: "/qor/bootstrap.sh"
  config.vm.provision "file", source: "qor_config/env.sh", destination: "/qor/env.sh"
  config.vm.provision "file", source: "qor_config/database.yml", destination: "/qor/database.yml"
  config.vm.provision "file", source: "qor_config/application.yml", destination: "/qor/application.yml"
  config.vm.provision "file", source: "qor_config/start.sh", destination: "/qor/start.sh"
  # copy golang tar over to host if locally present
  if File.exist?("qor_config/go1.9.2.linux-amd64.tar.gz")
    config.vm.provision "file", source: "qor_config/go1.9.2.linux-amd64.tar.gz", destination: "/qor/go1.9.2.linux-amd64.tar.gz"
  end 
  # configure host environment variables and file permissions
  config.vm.provision "shell", inline: "cp /qor/env.sh /etc/profile.d/Z99-env.sh", privileged: true
  config.vm.provision "shell", inline: "chmod 755 /etc/profile.d/Z99-env.sh", privileged: true
  config.vm.provision "shell", inline: "chmod 755 /qor/*"
  config.vm.provision "shell", inline: "chmod 755 /qor/bootstrap.sh"
  config.vm.provision "shell", inline: "touch /qor/bootstrap.log && chmod 722 /qor/bootstrap.log", privileged: true
  config.vm.provision "shell", inline: "echo 'source /qor/env.sh' >> ~/.profile", privileged: false
  config.vm.provision "shell", inline: "echo 'source /qor/env.sh' >> /root/.profile", privileged: true
  # run provisioning script
  config.vm.provision "shell", inline: "/bin/bash /qor/bootstrap.sh >> /qor/bootstrap.log", privileged: true
  # enabling synced folder slows down performance
  #config.vm.synced_folder "qordev", "/qor"
  # start qor site
  config.vm.provision "shell", inline: "/bin/bash /qor/start.sh >> /qor/bootstrap.log", privileged: true
  config.vm.post_up_message = "Find the QOR Example site here:"
  config.vm.post_up_message = "http://192.168.33.10:7000"
end
