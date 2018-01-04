#!/bin/bash

echo "cd $QORDIR/src/github.com/$REPO/qor-example/"
cd "$QORDIR/src/github.com/$REPO/qor-example/"
echo "starting 'main.go'"
nohup go run main.go >> "$QORDIR/bootstrap.log" &
ps aux | grep go >> "$QORDIR/bootstrap.log"