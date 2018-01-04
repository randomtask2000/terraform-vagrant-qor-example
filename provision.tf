resource "digitalocean_droplet" "qor-example" {
    image = "ubuntu-17-10-x64"
    name = "qor-example"
    region = "sfo2"
    size = "512mb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]
    connection {
        user = "root"
        type = "ssh"
        private_key = "${file(var.pvt_key)}"
        timeout = "10m"
    }
    provisioner "remote-exec" {
        inline = [
            "mkdir -m 777 /qor",
            "git config --global http.postBuffer 1048576000",
        ]
    }
    # copy files over from ./qor_config/
    provisioner "file" {
      source      = "qor_config/bootstrap.sh"
      destination = "/qor/bootstrap.sh"
    }
    provisioner "file" {
      source      = "qor_config/env.sh"
      destination = "/qor/env.sh"
    }
    provisioner "file" {
      source      = "qor_config/database.yml"
      destination = "/qor/database.yml"
    }
    provisioner "file" {
      source      = "qor_config/application.yml"
      destination = "/qor/application.yml"
    }
    provisioner "file" {
      source      = "qor_config/start.sh"
      destination = "/qor/start.sh"
    }
    # configure host environment variables
    provisioner "remote-exec" {
        inline = [
            "cp /qor/env.sh /etc/profile.d/Z99-env.sh",
            "chmod 755 /etc/profile.d/Z99-env.sh",
            "chmod 755 /qor/*",
            "chmod 755 /qor/bootstrap.sh",
            "touch /qor/bootstrap.log && chmod 722 /qor/bootstrap.log",
            "echo 'source /qor/env.sh' >> ~/.profile",
            "echo 'source /qor/env.sh' >> /root/.profile"
        ]
    }
    # add swapfile to 512 digitalocean host
    provisioner "remote-exec" {
        inline = [
            "sudo fallocate -l 1G /swapfile",
            "sudo chmod 600 /swapfile",
            "sudo mkswap /swapfile",
            "sudo swapon /swapfile",
            "sudo cp /etc/fstab /etc/fstab.bak",
            "sudo echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab",
            "sudo echo 'vm.vfs_cache_pressure=50' >> /etc/sysctl.conf",
        ]
    }
    # run provisioning script
    provisioner "remote-exec" {
        inline = [
            "/bin/bash /qor/bootstrap.sh >> /qor/bootstrap.log"
        ]
    }
    # start qor site
    provisioner "remote-exec" {
        inline = [
            "/bin/bash /qor/start.sh >> /qor/bootstrap.log"
        ]
    }
}
