#!/bin/bash
# Check syntax
if [ -z "$1" ]; then
  echo "Syntax : $0 [/path/to/ssh/pubkey]"
  exit
fi
export NEWPEMKEY=`ssh-keygen -e -m PEM -f $1`
sleep 1
echo "$NEWPEMKEY" > $1 # double quotes to preserve formatting
