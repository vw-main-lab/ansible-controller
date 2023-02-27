#!/bin/bash

# Function to remove existing keys in current directory
remove_existing_temp_keys () {
  for FILE in ssh_host_dsa_key ssh_host_rsa_key ssh_host_ecdsa_key ssh_host_ed25519_key ssh_host_dsa_key.pub ssh_host_rsa_key.pub ssh_host_ecdsa_key.pub ssh_host_ed25519_key.pub
  do
    if [ -f ./$FILE ]; then
      echo Removing existing key file in current directory $FILE
      rm -f ./$FILE
    fi
  done
}

# Check syntax
if [ -z "$1" ]; then
  echo "Syntax : $0 [input json file] [[outfile path]]"
  exit
fi

# Set variables
export inputjsonfile="$1" # e.g "template.json"
if [ -z "$2" ]; then
  export outputjsonfile="/dev/stdout"
else
  export outputjsonfile=$2
fi

# Check input file path
if [ ! -f "$inputjsonfile" ]; then
  echo "file not found : $inputjsonfile"
  exit
fi

# Get original json value
export outputjson=`cat "$inputjsonfile"`

# Delete temporary keys in current directory if already exist
remove_existing_temp_keys

# Generate new keys in current directory
echo "Generate dsa keys.."
ssh-keygen -q -N "" -t dsa -f ./ssh_host_dsa_key
echo "Generate rsa keys.."
ssh-keygen -q -N "" -t rsa -b 4096 -f ./ssh_host_rsa_key
echo "Generate ecdsa keys.."
ssh-keygen -q -N "" -t ecdsa -f ./ssh_host_ecdsa_key
echo "Generate ed25519 keys.."
ssh-keygen -q -N "" -t ed25519 -f ./ssh_host_ed25519_key

# Get keys values and add newline (= $'\n')
export dsakey=`cat "./ssh_host_dsa_key"`$'\n'
export dsapubkey=`cat "./ssh_host_dsa_key.pub"`$'\n'
export ecdsakey=`cat "./ssh_host_ecdsa_key"`$'\n'
export ecdsapubkey=`cat "./ssh_host_ecdsa_key.pub"`$'\n'
export ed25519key=`cat "./ssh_host_ed25519_key"`$'\n'
export ed25519pubkey=`cat "./ssh_host_ed25519_key.pub"`$'\n'
export rsakey=`cat "./ssh_host_rsa_key"`$'\n'
export rsapubkey=`cat "./ssh_host_rsa_key.pub"`$'\n'

# Delete temporary keys in current directory if already exist
remove_existing_temp_keys

# Replace values in outputjson variable
export outputjson=`echo $outputjson | jq '.hostkeys.dsa.private = env.dsakey'`
export outputjson=`echo $outputjson | jq '.hostkeys.dsa.public = env.dsapubkey'`
export outputjson=`echo $outputjson | jq '.hostkeys.ecdsa.private = env.ecdsakey'`
export outputjson=`echo $outputjson | jq '.hostkeys.ecdsa.public = env.ecdsapubkey'`
export outputjson=`echo $outputjson | jq '.hostkeys.ed25519.private = env.ed25519key'`
export outputjson=`echo $outputjson | jq '.hostkeys.ed25519.public = env.ed25519pubkey'`
export outputjson=`echo $outputjson | jq '.hostkeys.rsa.private = env.rsakey'`
export outputjson=`echo $outputjson | jq '.hostkeys.rsa.public = env.rsapubkey'`

# Export modified json content to specified file
echo $outputjson | jq . > "$outputjsonfile"
