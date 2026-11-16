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

shopt -s nullglob
OLD=( "$PREFIX"*.flac )

if [[ ${#OLD[@]} -eq 0 ]]
then
  echo "No FLAC files found matching ${PREFIX}*.flac"
  exit 1
fi

NEW=()
for (( a=0; a<${#OLD[@]}; a++ )); do
  NEW+=( "$(printf "%s%st%02d.flac" "$ID" "$INFIX" $((a+1)))" )
done

for (( a=0; a<${#OLD[@]}; a++ )); do
  echo "${OLD[a]}  ->  ${NEW[a]}"
done

read -p "Apply these ${#OLD[@]} renames? " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
  for (( a=0; a<${#OLD[@]}; a++ )); do
    mv -i "${OLD[a]}" "${NEW[a]}"
  done
fi
