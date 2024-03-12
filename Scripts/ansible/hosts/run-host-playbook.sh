#!/bin/bash

# Check syntax
if [ -z "$2" ]; then
  echo "Syntax : $0 [hostname] [tags]"
  echo "   e.g : $0 dbserver 'base,advanced'"
  exit
fi

# Set host name
export LAB_HOSTNAME="$1" # e.g "neptune"
export LAB_TAGS="$2"

# Set absolute path and hostname
export SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
export LAB_DIRECTORY=`readlink -f $SCRIPT_DIR/../../..`
#export LAB_DIRECTORY=`readlink -f ../../..`

# Set vars
export LAB_HOSTS_FILE="$LAB_DIRECTORY/Configuration Files/hosts/ansible-controller/ansible/hosts"
#~ export ANSIBLE_PRIVATE_KEY_FILE="$LAB_DIRECTORY/Configuration Files/hosts/ansible-controller/filesystem/home/lab/.ssh/id_rsa"
export ANSIBLE_REQUIREMENTS_FILE="$LAB_DIRECTORY/Configuration Files/hosts/$LAB_HOSTNAME/ansible/requirements.yml"
export LAB_HOST_CONFIGURATION_FILE="$LAB_DIRECTORY/Configuration Files/hosts/$LAB_HOSTNAME/ansible/host_settings.json"
export ANSIBLE_ROLES_TEMPDIR="$HOME/.ansible/roles_temp_$(date +%s)"
export ANSIBLE_ROLES_PATH="$ANSIBLE_ROLES_TEMPDIR"

# Save current dir
export my_currentdir="$PWD"

# Install requirements
ansible-galaxy install -f --force-with-deps -r "$ANSIBLE_REQUIREMENTS_FILE" -p "$ANSIBLE_ROLES_TEMPDIR"

if [ "$?" = "0" ]
then
    # Run playbook if requirements installation succeeded
    ansible-playbook "$LAB_DIRECTORY/Scripts/ansible/hosts/$LAB_HOSTNAME.yml" -v --inventory "$LAB_HOSTS_FILE" --tags "$LAB_TAGS" --skip-tags "dep_install_only" --extra-vars \
  "lab_base_dir='${LAB_DIRECTORY}' \
  lab_host_conf_file='${LAB_HOST_CONFIGURATION_FILE}'"
else
  echo "Error(s) while trying to install requirements"
fi

# Remove Ansible roles temporary dir
echo Removing Ansible roles temporary dir $ANSIBLE_ROLES_TEMPDIR
rm -rf $ANSIBLE_ROLES_TEMPDIR

# Get back to initial dir
cd "$my_currentdir"

# The End
echo Terminated.
