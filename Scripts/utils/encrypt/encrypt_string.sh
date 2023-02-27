#!/bin/bash
ansible-vault encrypt_string --vault-id dev@a_password_file --stdin-name 'new_user_password'
