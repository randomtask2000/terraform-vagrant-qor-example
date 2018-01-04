export VERSION=1.9.2
export OS=linux
export ARCH=amd64
export QORDIR=/qor
export QORUSER=qor
if [ "${PATH#*/usr/local/go/bin}" = "${PATH}" ]; then
    export PATH=$PATH:/usr/local/go/bin
fi
export GOROOT=/usr/local/go
export GOPATH=$QORDIR
export REPO=qor
