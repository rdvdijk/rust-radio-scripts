#!/bin/bash
#
# This script converts FLAC files to MP3 files.
# The FLAC audio, tags and cover art are converted.
#
# Requires: flac and lame.
#

checkInstalled() { if ! [ -x "$(command -v $1)" ]; then echo "'$1' could not be found"; exit 1; fi }

checkInstalled flac
checkInstalled lame

getTag() {
  local file=$1
  local tag=$2
  echo $(metaflac "$file" --show-tag=$tag | sed s/.*=//g)
}

for flacfile in *.flac; do
  ARTWORK=/tmp/flac2mp3.artwork
  MP3FILE="mp3/${flacfile%.flac}.mp3"

  echo "Converting: $flacfile --> $MP3FILE"

  ARIST=$(getTag "$flacfile" ARTIST)
  TITLE=$(getTag "$flacfile" TITLE)
  ALBUM=$(getTag "$flacfile" ALBUM)
  GENRE=$(getTag "$flacfile" GENRE)
  TRACKNUMBER=$(getTag "$flacfile" TRACKNUMBER)
  DATE=$(getTag "$flacfile" DATE)

  INCLUDEART=""
  metaflac --export-picture-to=$ARTWORK "$flacfile"
  if [[ -f $ARTWORK ]]; then
    INCLUDEART=true
  fi

  mkdir -p mp3
  flac -s -c -d "$flacfile" | \
    lame --silent -m j -q 0 --vbr-new -V 0 -s 44.1 \
    --add-id3v2 \
    --tt "$TITLE" \
    --ta "$ARTIST" \
    --tl "$ALBUM" \
    --ty "${DATE:0:4}" \
    --tg "${GENRE:-12}" \
    ${INCLUDEART:+ --ti $ARTWORK} \
    --tn "${TRACKNUMBER:-0}" \
    - "$MP3FILE"

  if [[ -f $ARTWORK ]]; then
    rm $ARTWORK
  fi
done
