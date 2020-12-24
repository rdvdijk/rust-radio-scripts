#!/bin/bash

#
# Get a single tag value.
#
tag_value () {
  local file=$1
  local tag=$2
  echo $(metaflac --show-tag=$tag $file | cut -f2 -d"=")
}
export -f tag_value

#
# Print tags for a FLAC file.
#
print_tags () {
  set -f
  local file=$1

  local tracknumber=$(tag_value $file TRACKNUMBER)
  local title=$(tag_value $file TITLE)
  local artist=$(tag_value $file ARTIST)
  local date=$(tag_value $file DATE)
  local album=$(tag_value $file ALBUM)

  printf "%s. %-40s| %s | %s | %s\n" "$tracknumber" "$title" "$artist" "$date" "$album"
}
export -f print_tags

find . -maxdepth 1 -name "*.flac" -print0 |
  sort -z |
  xargs -0 bash -c 'for f; do print_tags "$f"; done' _

