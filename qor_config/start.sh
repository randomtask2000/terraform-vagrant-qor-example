#!/bin/bash

cd "$QORDIR/src/github.com/$REPO/qor-example/"
#go run main.go
echo "starting 'main.go'"
nohup go run main.go >> "$QORDIR/bootstrap.log" 2>&1 &