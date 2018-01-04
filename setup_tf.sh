#!/bin/sh
# setup and run terraform commands with environment secrets
# https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean
if [ -z "$1" ]; then
    set -- "apply"
fi
FINGERPRINT=`ssh-keygen -E md5 -lf ~/.ssh/id_rsa.pub | awk '{ gsub("MD5:","",$2); print $2}'`
echo "FINGERPRINT=$FINGERPRINT"
echo "digitalocean_key=$TF_VAR_digitalocean_token"
echo "terraform_cmd=$1"
echo "github_secret=$GIT_QOR_EXAMPLE"
# add github application key
sed -i -e 's/your github client id/qor\-example/g' ./qor_config/application.yml
sed -i -e 's/your github client secret/'"$GIT_QOR_EXAMPLE"'/g' ./qor_config/application.yml
echo "running:"
echo "terraform $1 \ "
echo "    -var \"do_token=$TF_VAR_digitalocean_token\" \ "
echo "    -var \"pub_key=$HOME/.ssh/id_rsa.pub\" \ "
echo "    -var \"pvt_key=$HOME/.ssh/id_rsa\" \ "
echo "    -var \"ssh_fingerprint=$FINGERPRINT\" "
# run terraform command
terraform $1 \
    -var "do_token=$TF_VAR_digitalocean_token" \
    -var "pub_key=$HOME/.ssh/id_rsa.pub" \
    -var "pvt_key=$HOME/.ssh/id_rsa" \
    -var "ssh_fingerprint=$FINGERPRINT"
# set qor application file back to defaults
cat <<EOT > qor_config/application.yml
github:
  clientid: 'your github client id'
  clientsecret: 'your github client secret'
google:
  clientid: 'your google client id'
  clientsecret: 'your google client secret'
facebook:
  clientid: 'your facebook client id'
  clientsecret: 'your facebook client secret'
twitter:
  clientid: 'your twitter client id'
  clientsecret: 'your twitter client secret'
EOT
