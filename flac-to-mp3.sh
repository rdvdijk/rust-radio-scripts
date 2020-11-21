#!/bin/bash
#
# This script converts FLAC files to MP3 files.
#
# Requires: flac, lame and id3.
#

checkInstalled() { if ! [ -x "$(command -v $1)" ]; then echo "'$1' could not be found"; exit 1; fi }

checkInstalled flac
checkInstalled lame
checkInstalled id3

getTag() {
  local file=$1
  local tag=$2
  echo $(metaflac "$file" --show-tag=$tag | sed s/.*=//g)
}

for flacfile in *.flac; do
  echo "$flacfile"

  MP3FILE="mp3/${flacfile%.flac}.mp3"

  ARIST=$(getTag "$flacfile" ARTIST)
  TITLE=$(getTag "$flacfile" TITLE)
  ALBUM=$(getTag "$flacfile" ALBUM)
  GENRE=$(getTag "$flacfile" GENRE)
  TRACKNUMBER=$(getTag "$flacfile" TRACKNUMBER)
  DATE=$(getTag "$flacfile" DATE)

  mkdir -p mp3
  flac -c -d "$flacfile" | lame -m j -q 0 --vbr-new -V 0 -s 44.1 - "$MP3FILE"
  id3 -t "$TITLE" -T "${TRACKNUMBER:-0}" -a "$ARTIST" -A "$ALBUM" -y "$DATE" -g "${GENRE:-12}" "$MP3FILE"
done
