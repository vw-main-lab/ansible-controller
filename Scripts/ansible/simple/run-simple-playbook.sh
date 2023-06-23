#!/bin/bash

# Check syntax
if [ -z "$1" ]; then
  echo "Syntax : $0 [scriptname]"
  echo "   e.g : $0 dbserver"
  exit
fi

# Set host name
export LAB_SCRIPTNAME="$1"

# Set absolute path and hostname
export SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
export LAB_DIRECTORY=`readlink -f $SCRIPT_DIR/../../..`

# Set vars
export LAB_HOSTS_FILE="$LAB_DIRECTORY/Configuration Files/hosts/ansible-controller/ansible/hosts"
export ANSIBLE_PRIVATE_KEY_FILE="$LAB_DIRECTORY/Configuration Files/hosts/ansible-controller/filesystem/home/lab/.ssh/id_rsa"

# Save current dir
export my_currentdir="$PWD"

# Run playbook
ansible-playbook "$LAB_DIRECTORY/Scripts/ansible/simple/$LAB_SCRIPTNAME.yml" -v --inventory "$LAB_HOSTS_FILE" --extra-vars \
  "lab_base_dir='${LAB_DIRECTORY}'"

# Get back to initial dir
cd "$my_currentdir"

# The End
echo Terminated.
