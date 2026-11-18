#!/bin/bash
#
# Runs flac-tagger.sh in every sub-subfolder of the current folder, using the
# folder's shortest .txt filename as infofile (so "show.txt" wins over
# "show.ffp.txt"). Asks for confirmation per folder.
#

# readlink, so this also works when called through a symlink.
SCRIPTDIR=$(dirname "$(readlink -f "$0")")

shopt -s nullglob

for dir in */*/; do
  (
    cd "$dir" || exit
    echo "== $dir"

    infofile=""
    for f in *.txt; do
      if [[ -z "$infofile" || ${#f} -lt ${#infofile} ]]; then
        infofile="$f"
      fi
    done

    if [[ -z "$infofile" ]]; then
      echo "No .txt file found, skipping"
      exit
    fi

    read -p "Tag using $infofile? [y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      "$SCRIPTDIR/flac-tagger.sh" "$infofile"
    fi
  )
done
