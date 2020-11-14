#!/bin/bash
#
# This script removes all previously created checksum files:
# - *md5*
# - *ffp*
# - *st5*
# - *fingerprint*
#
# NOTE: files are moved to the /tmp folder.
#

while IFS= read -r -d '' file; do
  if [[ -e $file ]]
  then
    echo "- ${file:2}"
    mv "${file}" /tmp
  fi
done < <(find \( -name '*md5*' -o -name '*fingerprint*' -o -name '*ffp*' -o -name '*st5*' \) -a -print0)
