#!/bin/bash
# Check syntax
if [ -z "$2" ]; then
  echo "Syntax : $0 [input keys dir] [input json file] [[outfile path]]"
  exit
fi

# Set variables
export inputkeysdir="$1" # e.g "/etc/ssh"
export inputjsonfile="$2" # e.g "template.json"
if [ -z "$3" ]; then
  export outputjsonfile="/dev/stdout"
else
  export outputjsonfile=$3
fi

# Check input directory path
if [ ! -d "$inputkeysdir" ]; then
  echo "directory not found : $inputkeysdir"
  exit
fi

# Check input file path
if [ ! -f "$inputjsonfile" ]; then
  echo "file not found : $inputjsonfile"
  exit
fi

# Get original json value
export outputjson=`cat "$inputjsonfile"`

# Get keys values and add newline (= $'\n')
export dsakey=`cat "$inputkeysdir/ssh_host_dsa_key"`$'\n'
export dsapubkey=`cat "$inputkeysdir/ssh_host_dsa_key.pub"`$'\n'
export ecdsakey=`cat "$inputkeysdir/ssh_host_ecdsa_key"`$'\n'
export ecdsapubkey=`cat "$inputkeysdir/ssh_host_ecdsa_key.pub"`$'\n'
export ed25519key=`cat "$inputkeysdir/ssh_host_ed25519_key"`$'\n'
export ed25519pubkey=`cat "$inputkeysdir/ssh_host_ed25519_key.pub"`$'\n'
export rsakey=`cat "$inputkeysdir/ssh_host_rsa_key"`$'\n'
export rsapubkey=`cat "$inputkeysdir/ssh_host_rsa_key.pub"`$'\n'

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
