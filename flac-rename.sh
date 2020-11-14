#!/bin/bash
#
# This script renames FLAC files based on the current folder name.
#

DIRNAME=${PWD##*/}
ID=$(gawk -v dirname="$DIRNAME" 'BEGIN { show=gensub(/([a-z]*[0-9]*-[0-9]*-[0-9]*)(.*)/,"\\1", "g", dirname); print show }')

# optional: match only this prefix
if [[ -n "$1" ]]
then
  PREFIX="$1"
  echo "matching prefix: $PREFIX "
fi

# optional: add this infix
if [[ -n "$2" ]]
then
  INFIX="$2"
  echo "inserting infix: $INFIX"
fi

read -p "Rename FLAC files to ${ID}${INFIX}t00.flac. Are you sure? " -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo
  a=1
  for i in $PREFIX*.flac; do
    new=$(printf "${ID}${INFIX}t%02d.flac" ${a}) #04 pad to length of 4
    echo "${new}  (was: ${i})"
    mv -i "${i}" "${new}"
    let a=a+1
  done
fi
