#!/bin/sh
# setup and run vagrant vbox
# if no params were passed run destroy, build, provision and ssh into the box
if [ -z "$1" ]; then
    set -- "vagrant up"
fi
echo "vagrant_cmd=vagrant $1"
echo "github_secret=$GIT_QOR_EXAMPLE"
# add github application key
sed -i '' -e 's/your github client id/qor-example/g' ./qor_config/application.yml
sed -i '' -e 's/your github client secret/'"$GIT_QOR_EXAMPLE"'/g' ./qor_config/application.yml
echo "running:"
echo "$@"
# run vagrant command
if [[ $1 == vagrant* ]] ; then
  eval "$@"
else 
  vagrant "$@"
fi
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