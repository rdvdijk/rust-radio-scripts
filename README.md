# Rust Radio scripts

This is a collection of bash scripts that I (@rdvdijk) use on the
Rust Radio server. Most of the scripts relate to the maintenance 
of FLAC shows.

## flac-rename.sh

Rename the FLAC files in the current folder according to the
[etree.org naming standard](http://wiki.etree.org/index.php?page=NamingStandards).
This script assumes that the folder itself has already been renamed
accordingly.

Alias: `flacrn`

## flac-tagger.sh

Tags FLAC files using an infofile that contains show information
and song titles. This script requires
[a specific fork](https://github.com/rdvdijk/flactagger/tree/combined-album)
of the `flactagger.rb` Ruby script, originally written by Tochiro.

Alias: `ft`

## flac-create-ffp.sh

Create a `.ffp.txt` file of FLAC fingerprints in the current folder.

Alias: `ffp`

## flac-length.sh

Print the length of a set of FLAC files in [H:MM:SS] format.

To print the length of 'disks', these scripts can be used:

* flac-length-d1.sh
* flac-length-d2.sh
* flac-length-d3.sh

Alias: `dlen`

## flac-to-mp3.sh

Convert the FLAC files in the current directory to MP3 files.

Alias: `flac2mp3`

## remove-checksums.sh

Remove the `ffp`, `md5`, `fingerprint` and `st5` checksums in the
current folder.

Alias: `rmchecksums`

## wav-to-16bit-44khz.sh

Convert the `.wav` files in the current folder to 16-bit 44kHz
files.

Alias: `to1644`

## backup-infofile.sh

Rename a show infofile according to the etree.org naming standard,
and create a backup of the original.

Alias: `orig`

## flac-print-tags.sh

Print a table of FLAC tags in the current directory.

Alias: `pt`

## wav-tweak-fffe-header.sh

Replaces the `WAVE_FORMAT_EXTENSIBLE` header with `WAVE_FORMAT_PCM`,
to allow some code (like `ssrc_hp`) to work again.

Alias: `tweakwav`

