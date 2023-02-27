#!/bin/bash
# Check syntax
if [ -z "$1" ]; then
  echo "Syntax : $0 [input file] [[output file]]"
  exit
fi

# Set variables
export inputfile="$1" # e.g "template.txt"
if [ -z "$2" ]; then
  export outputfile="/dev/stdout"
else
  export outputfile=$2
fi

# Check input file path
if [ ! -f "$inputfile" ]; then
  echo "file not found : $inputfile"
  exit
fi

jq -R -s '.' < $1 > "$outputfile"
