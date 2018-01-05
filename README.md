terraform-vagrant-qor-example
=============================
A VERY simple [QOR-Example](https://github.com/randomtask2000/qor-example) eCom Shop environment provisioner for [HashiCorp Vagrant](http://www.vagrantup.com/) and [HashiCorp Terraform](https://www.terraform.io/) on [DigitalOcean](https://www.digitalocean.com/).
## Introduction
This set of scripts can instantiate a local shopping site running [QOR-Example](https://github.com/randomtask2000/qor-example) on [Golang](https://golang.org/) in a local [Vagrant](https://www.vagrantup.com) [virtual box](https://www.virtualbox.org/wiki/Downloads) (vbox) or a small 512 instance in [DigitalOcean](https://cloud.digitalocean.com) via [HashiCorp Terraform](https://www.terraform.io/). 
## Quick Start
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
# QOR example application
Learn more about QOR and what it does [here](http://getqor.com): [QOR](http://getqor.com).

QOR Chat Room: [![Join the chat at https://gitter.im/qor/qor](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/qor/qor?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

