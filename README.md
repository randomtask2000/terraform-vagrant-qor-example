## Introduction
This set of scripts can instantiate a local shopping site running [QOR-Example](https://github.com/randomtask2000/qor-example) on [Golang](https://golang.org/) in a local [Vagrant](https://www.vagrantup.com) [virtual box](https://www.virtualbox.org/wiki/Downloads) (vbox) or a small 512 instance in [DigitalOcean](https://cloud.digitalocean.com) via [HashiCorp Terraform](https://www.terraform.io/). 

## Installation & Usage
You'll need to have the following environment variables set in your profile
```
export TF_VAR_digitalocean_token=[your digitalocean application secret]
export GIT_QOR_EXAMPLE=[your github application secret]
```
Run the Vagrant instance with
```
./setup_vagrant.sh
```
Or start your DigitalOcean instance:
```
./setup_tf.sh apply
```
After running the above you can find your site on the allocated `IP address` and `port 7000`. The site on `Vagrant` can be found at http://192.168.33.10:7000

