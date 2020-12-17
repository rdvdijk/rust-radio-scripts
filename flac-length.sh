#!/bin/bash
#
# Script to print the length of a FLAC show in [H:MM:SS] format.
# The optional first argument is a substring match, which can be 
# used to match disks, e.g. 'd1' or 'd2'.
#
# This script uses the 'shnlen' command.
#

checkInstalled() { if ! [ -x "$(command -v $1)" ]; then echo "'$1' could not be found"; exit 1; fi }

checkInstalled shnlen

if [[ -z "$1" ]]
then
  ID=*.flac
else
  ID=*$1*.flac
fi

shnlen $ID | while read line
do
  if [[ -n "$line" ]]
  then
    if [[ "$line" == *-b-* ]]; then
      echo "sbe!"
      break
    elif [[ "$line" =~ .*files?\).* ]]; then
      echo $line | awk '{
        min=gensub(/([0-9]*):([0-9]*).([0-9]*)/, "\\1", 1, $1); 
        sec=gensub(/([0-9]*):([0-9]*).([0-9]*)/, "\\2", 1, $1); 
        printf "["
        printf substr(min/60,1,1) 
        printf ":" 
        printf "%02.0f",min%60 
        printf ":" sec 
        printf "]\n" 
      }'
    fi
  fi
done
