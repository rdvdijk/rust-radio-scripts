#!/bin/bash
#
# This script renames FLAC files based on the current folder name.
#
# Usage: flac-rename.sh [PREFIX [INFIX]]
#
# PREFIX only matches files starting with it, INFIX is inserted before the
# track number. After seeing the proposed renames, press 'd' to enter a
# prefix and infix interactively (e.g. "D1 d1"), once per disc.
#

DIRNAME=${PWD##*/}
ID=$(gawk -v dirname="$DIRNAME" 'BEGIN { show=gensub(/([a-z]*[0-9]*-[0-9]*-[0-9]*)(.*)/,"\\1", "g", dirname); print show }')

PREFIX="$1"
INFIX="$2"

shopt -s nullglob

ask_prefix_infix () {
  read -r -p "Prefix and infix (e.g. 'D1 d1', empty to quit): " PREFIX INFIX
  [[ -n "$PREFIX" ]]
}

while true; do
  [[ -n "$PREFIX" ]] && echo "matching prefix: $PREFIX"
  [[ -n "$INFIX" ]] && echo "inserting infix: $INFIX"

  FILES=( "$PREFIX"*.flac )
  OLD=()
  NEW=()
  for (( a=0; a<${#FILES[@]}; a++ )); do
    new=$(printf "%s%st%02d.flac" "$ID" "$INFIX" $((a+1)))
    # Files already named correctly keep their number but are skipped, as
    # 'mv -i' refuses to move a file onto itself.
    if [[ "${FILES[a]}" != "$new" ]]; then
      OLD+=( "${FILES[a]}" )
      NEW+=( "$new" )
    fi
  done

  if [[ ${#FILES[@]} -eq 0 ]]; then
    echo "No FLAC files found matching ${PREFIX}*.flac"
    [[ -z "$PREFIX" ]] && exit 1
  elif [[ ${#OLD[@]} -eq 0 ]]; then
    echo "No renames required"
    [[ -z "$PREFIX" ]] && exit 0
  else
    for (( a=0; a<${#OLD[@]}; a++ )); do
      echo "${OLD[a]}  ->  ${NEW[a]}"
    done

    read -p "Apply these ${#OLD[@]} renames? [y]es, [n]o, [d]isc prefix/infix: " -n 1 -r
    echo

    case "$REPLY" in
      [Yy])
        for (( a=0; a<${#OLD[@]}; a++ )); do
          mv -i "${OLD[a]}" "${NEW[a]}"
        done
        [[ -z "$PREFIX" ]] && exit 0
        ;;
      [Dd])
        ask_prefix_infix || exit 0
        continue
        ;;
      *)
        exit 0
        ;;
    esac
  fi

  ask_prefix_infix || exit 0
done
