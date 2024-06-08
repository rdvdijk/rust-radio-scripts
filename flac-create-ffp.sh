#!/bin/bash
#
# This script creates a .ffp.txt file for FLAC files in the current folder.
#

DIRNAME=${PWD##*/}
ID=$(gawk -v dirname="$DIRNAME" 'BEGIN { show=gensub(/([a-z]*[0-9]*-[0-9]*-[0-9]*)(.*)/,"\\1", "g", dirname); print show }')
FFPFILE=$ID.ffp.txt

if [ -e $FFPFILE ]
then
  echo "ffp file already exists!"
else
  echo "creating $FFPFILE"
  metaflac --with-filename --show-md5sum *.flac > $FFPFILE
fi
