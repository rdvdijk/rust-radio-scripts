#!/bin/bash
#
# This script renames FLAC folders, and adds the city name as found in the info file.
#

add_location () {
  local path=$1

  local dirname=${path##*/}
  local showprefix=$(gawk -v dirname="$dirname" 'BEGIN { show=gensub(/([a-z]*[0-9]*-[0-9]*-[0-9]*)(.*)/,"\\1", "g", dirname); print show }')
  local showsuffix=$(gawk -v dirname="$dirname" 'BEGIN { show=gensub(/([a-z]*[0-9]*-[0-9]*-[0-9]*)(.*)/,"\\2", "g", dirname); print show }')
  local infofile="$path/$showprefix.txt"

  if [[ -f "$infofile" ]]; then
    local locations=$(head -n3 "$infofile" | tail -n1 | cut -d, -f1 | tr '[:upper:]' '[:lower:]')
    local location=${locations// /}
    local expected="$showprefix.$location"

    if [[ ! "$dirname" =~ ^$expected.* ]]; then
      local newdirname="$showprefix.$location$showsuffix"
      mv -i "$dirname" "$newdirname"
    fi
  fi
}

export -f add_location

find -mindepth 1 -maxdepth 1 -type d -exec bash -c 'add_location "$0"' {} \;
