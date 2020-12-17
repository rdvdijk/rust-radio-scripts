#!/bin/bash
#
# This script backs up the original text-file of a show 
# and creates a copy with the correct name.
#

if [[ -z "$1" ]]
then
  echo "Usage: orig [file]"
  exit
fi

DIRNAME=${PWD##*/}
ID=$(awk -v dirname="$DIRNAME" 'BEGIN { show=gensub(/([a-z]*[0-9]*-[0-9]*-[0-9]*)(.*)/,"\\1", "g", dirname); print show }')

NEW="${ID}.orig.txt"
COPY="${ID}.txt"

# Create backup
if [[ -e ${NEW} ]]
then
  echo "${NEW} already exists!"
  exit
else
  mv "${1}" "${NEW}"
fi

# Create fresh copy
if [[ -e ${COPY} ]]
then
  echo "${COPY} already exists!"
  exit
else
  cp "${NEW}" "${COPY}"
fi

