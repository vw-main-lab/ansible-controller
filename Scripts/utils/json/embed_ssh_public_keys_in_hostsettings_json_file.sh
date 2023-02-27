#!/bin/bash

# Check syntax
if [ -z "$2" ]; then
  echo "Syntax : $0 [input keys] [input json file] [username] [[outfile path]]"
  exit
fi

# Set variables
export inputkeys="$1" # e.g "/home/john/.ssh/*.pub"
export inputjsonfile="$2" # e.g "template.json"
export outputusername="$3" # e.g "john"
if [ -z "$4" ]; then
  export outputjsonfile="/dev/stdout"
else
  export outputjsonfile=$4
fi

# Check input keys
#find "$inputkeys" 2> /dev/null > /dev/null
#if [ "$?" != "0" ]; then
#  echo "input keys not found : $inputkeys"
#  exit
#fi

# Check input file path
if [ ! -f "$inputjsonfile" ]; then
  echo "file not found : $inputjsonfile"
  exit
fi

# Get original json value
export outputjson=`cat "$inputjsonfile"`

# Get keys values and add newline (= $'\n')
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for FILE in $inputkeys
do
  export authkeyscontent=$authkeyscontent`cat $FILE`$'\n'
  echo Processed $FILE
done
IFS=$SAVEIFS

# Replace value in outputjson variable
export outputjson=`echo $outputjson | jq '.users |= map(if .name == env.outputusername then .authorized_keys = env.authkeyscontent else . end)'`

# Export modified json content to specified file
echo $outputjson | jq . > "$outputjsonfile"
