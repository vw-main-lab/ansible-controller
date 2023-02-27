#!/bin/bash
# Check syntax
if [ -z "$1" ]; then
  echo "Syntax : $0 [/path/to/keyfile]"
  exit
fi
ssh-keygen -p -N "" -m pem -f $1
