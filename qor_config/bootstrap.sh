#!/bin/bash
echo "provision host..."
export VERSION=1.9.2
export OS=linux
export ARCH=amd64
export QORDIR=/qor
export QORUSER=qor
export REPO=qor
echo "add '$QORUSER' user"
if  id "$QORUSER" >/dev/null 2>&1; then
    echo "$QORUSER is a user"
else 
    adduser --disabled-password --gecos "" "$QORUSER"
    adduser "$QORUSER" sudo
fi
if [ ! -f "$QORDIR" ]; then 
    mkdir -p -m 777 "$QORDIR"
else 
        chmod -R 777 "$QORDIR" 
fi
chown -R "$QORUSER" "$QORDIR"
echo "update host..."
apt-get -y update
apt-cache showpkg ack-grep
apt-get -y autoremove
apt-get -y install build-essential
cd "$QORDIR"
echo "install mysql..."
# don't try to remove this or else the install will give you the pink screen
export DEBIAN_FRONTEND=noninteractive
apt-get -q -y install mysql-server mysql-client
apt-get clean
apt-get clean all
echo "enable mysql root login..."
mysql -u root -e "CREATE DATABASE IF NOT EXISTS qor_example;"
mysql -u root -e "USE mysql; UPDATE mysql.user SET plugin='mysql_native_password' WHERE User='root';FLUSH PRIVILEGES;"
mysql -u root -e "USE mysql; CREATE USER 'qor' IDENTIFIED BY 'qor';
GRANT ALL PRIVILEGES ON *.* to 'qor' WITH GRANT OPTION;
FLUSH PRIVILEGES;";
service mysql restart
echo "about to install golang 'go$VERSION.$OS-$ARCH.tar.gz'..."
echo "/bin/tar -C /usr/local -xzf $QORDIR/go$VERSION.$OS-$ARCH.tar.gz"
if [ ! -f "$QORDIR/go$VERSION.$OS-$ARCH.tar.gz" ]; then
    wget "https://redirector.gvt1.com/edgedl/go/go$VERSION.$OS-$ARCH.tar.gz"
fi
/bin/tar -C /usr/local -xzf "$QORDIR/go$VERSION.$OS-$ARCH.tar.gz"
if [ ! -d /usr/local/go/bin ]; then 
    echo "go was not installed!" 
else 
    echo "go is installed!"
    export PATH=$PATH:/usr/local/go/bin
    export GOROOT=/usr/local/go
    export GOPATH=$QORDIR
    echo "install qor-example site..."
    cd "$QORDIR"
    go get -u "github.com/$REPO/qor-example"
    if [ ! -d "$QORDIR/src/github.com/$REPO/qor-example" ]; then 
        echo "qor was not installed!" 
    else 
        echo "git repos..."
        cd "$QORDIR/src/github.com/$REPO/qor-example"
        git remote add fork https://github.com/randomtask2000/qor-example.git
        git fetch fork old
        git checkout old
        echo "copying qor configurations to branch..."
        cp "$QORDIR/database.yml" "$QORDIR/src/github.com/$REPO/qor-example/config"
        cp "$QORDIR/application.yml" "$QORDIR/src/github.com/$REPO/qor-example/config"
        chown -R qor:qor /qor
        chmod -R 777 "$QORDIR/src/github.com/$REPO/"
        echo "installing qor dependencies..."
        cd "$QORDIR"
        go get -u github.com/azumads/faker
        go get -u github.com/qor/filebox
        if [ ! -d "$QORDIR/src/github.com/azumads/faker" ]; then 
            echo "package 'azumads/faker' was not installed!" 
        else 
            echo "seed qor website with data..."
            cd "$QORDIR/src/github.com/$REPO/qor-example"
            # the below doesn't work in the master branch
            #go run config/db/seeds/main.go config/db/seeds/seeds.go
            # works in old branch
            go run db/seeds/main.go db/seeds/seeds.go
            echo "stashing 'old' branch changes"
            git stash
            echo "switching to master"
            git checkout master 
            echo "copying qor configurations to master..."
            cp "$QORDIR/database.yml" "$QORDIR/src/github.com/$REPO/qor-example/config"
            cp "$QORDIR/application.yml" "$QORDIR/src/github.com/$REPO/qor-example/config"
            chown -R qor:qor /qor
            chmod -R 777 "$QORDIR/src/github.com/$REPO/"
        fi 
        echo "qor is installed!"
        echo "manually run:"
        echo "  cd $QORDIR/src/github.com/$REPO/qor-example/"
        echo "  go run main.go"
        echo "we are done!"
    fi
fi
echo "environment settings are:"
echo "\$VERSION=$VERSION"
echo "\$OS=$OS"
echo "\$ARCH=$ARCH"
echo "\$QORDIR=$QORDIR"
echo "\$QORUSER=$QORUSER"
echo "\$PATH=$PATH"
echo "\$GOROOT=$GOROOT"
echo "\$GOPATH=$GOPATH"
echo "\$REPO=$REPO"




