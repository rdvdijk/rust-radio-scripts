#!/bin/bash
#
# Script to tag FLAC files using an infofile.
#
# Requires: flactagger.rb
# https://github.com/rdvdijk/flactagger/tree/combined-album
#

checkInstalled() { if ! [ -x "$(command -v $1)" ]; then echo "'$1' could not be found"; exit 1; fi }

checkInstalled flactagger.rb

if [ -z "$1" ]
then
  echo "Usage: ft infofile.txt [genre]"
  exit
else
  INFOFILE=$1
fi

head -n6 $INFOFILE

if [ -z "$2" ]
then
  echo -n "Genre: "
  read -e GENRE
else
  GENRE=$2
  echo "Genre: $GENRE"
  echo
fi

flactagger.rb -T a -m b -r -t "GENRE=$GENRE" -B -p -i $INFOFILE *.flac

# create .ffp.txt file:
ffp

