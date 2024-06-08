#!/bin/bash
#
# This script converts a folder of 24-bit FLAC files to 16-bit/44.1kHz FLAC files.
#
DIRNAME=${PWD##*/}
NEWDIRNAME=$(gawk -v dirname="$DIRNAME" 'BEGIN { foldername=gensub(/flac24/, "flac16", "g", dirname); print foldername }')

mkdir $NEWDIRNAME
flac -d *.flac
tweakwav
to1644 $NEWDIRNAME
rm *.wav
cp *.txt $NEWDIRNAME
cd $NEWDIRNAME
rmchecksums
flac --best --sector-align --delete-input-file *.wav
cd ..

echo "Converted FLAC files to 16-bit/44.1kHz, don't forget to update info file."

