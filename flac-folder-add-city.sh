#!/bin/bash
#
# This script renames FLAC folders, and adds the city name as found in the info file.
# The script assumes the location to be located on the 4th line of the info file.
#

add_location () {
  local path=$1
  local force=$2

  local dirname=${path##*/}
  local showid=$(gawk -v dirname="$dirname" 'BEGIN { show=gensub(/([a-z]*[0-9]*-[0-9]*-[0-9]*)(.*)/,"\\1", "g", dirname); print show }')
  local infofile="$path/$showid.txt"

  local showprefix=$(gawk -v dirname="$dirname" 'BEGIN { show=gensub(/([a-z]*[0-9]*-[0-9]*-[0-9]*(\.(late|early))?)(.*)/,"\\1", "g", dirname); print show }')
  local showsuffix=$(gawk -v dirname="$dirname" 'BEGIN { show=gensub(/([a-z]*[0-9]*-[0-9]*-[0-9]*(\.(late|early))?)(.*)/,"\\4", "g", dirname); print show }')

  if [[ -f "$infofile" ]]; then
    local locations=$(head -n4 "$infofile" | tail -n1 | cut -d, -f1 | tr '[:upper:]' '[:lower:]' | tr -d "." | tr -d "-" | tr -d "[:space:]" )
    local location=${locations// /}
    local expected="$showprefix.$location"

    if [[ ! "$dirname" =~ ^$expected.* ]]; then
      local newdirname="$showprefix.$location$showsuffix"
      if [[ -z "$force" ]]; then
        printf "mv -i %-50s %s\n" "\"$dirname\"" "\"$newdirname\""
      else
        mv -i "$dirname" "$newdirname"
      fi
    fi
  fi
}

export -f add_location

while getopts "f" opt
do
  case "${opt}" in
    f) force=1
      ;;
  esac
done

find -mindepth 1 -maxdepth 1 -type d -exec bash -c "add_location \"\$0\" \"$force\"" {} \;
