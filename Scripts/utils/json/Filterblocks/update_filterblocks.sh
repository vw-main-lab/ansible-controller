#!/bin/bash
source Filterblocks/bin/activate
python3 UpdateFilterblocks.py $1 > /tmp/test.json
