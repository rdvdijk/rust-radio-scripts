#!/bin/bash
#
# This script converts WAV files to 16-bit 44.1kHz variants.
#
# Requires: ssrc_hp
# http://shibatch.sourceforge.net/download/ssrc-1.33.tar.gz
#

checkInstalled() { if ! [ -x "$(command -v $1)" ]; then echo "'$1' could not be found"; exit 1; fi }

checkInstalled ssrc_hp

FOLDER="441"

if [[ -n "$1" ]]
then
  FOLDER="$1"
  echo "saving files in: $FOLDER"
fi

mkdir -p $FOLDER
find . -name "*.wav" \
  -exec ssrc_hp \
  --bits 16 \
  --rate 44100 \
  --twopass \
  --dither 3 \
  --pdf 1 1 \
  {} \
  $FOLDER/{} \;
