#!/bin/bash
# Check syntax
if [ -z "$1" ]; then
  echo "Syntax : $0 [/path/to/ssh/pubkey]"
  exit
fi
export NEWSSHKEY=`ssh-keygen -e -f $1`
sleep 1
echo "$NEWSSHKEY" > $1 # double quotes to preserve formatting
