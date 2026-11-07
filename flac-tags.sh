#!/usr/bin/env bash
#
# Save the tags (Vorbis comments) of FLAC files and restore them later onto
# edited copies with the same file names.
#
# Usage:
#   flac-tags.sh save    TAGDIR FILE.flac...
#   flac-tags.sh restore TAGDIR FILE.flac...
#
# Tags are stored as TAGDIR/<file name>.vc, keyed by file name only, so the
# edited files may live in a different directory than the originals.
#
# The raw VORBIS_COMMENT metadata block is saved rather than a NAME=VALUE text
# export, because the text format cannot round-trip values containing newlines
# (e.g. lyrics). To inspect a saved file's tags, use:
#   metaflac --list --block-type=VORBIS_COMMENT FILE.flac

set -euo pipefail

usage() {
    echo "Usage: ${0##*/} save|restore TAGDIR FILE.flac..." >&2
    exit 2
}

die() {
    echo "${0##*/}: $*" >&2
    exit 1
}

save() {
    local tagdir=$1; shift
    mkdir -p -- "$tagdir"

    declare -A seen=()
    local f name
    for f in "$@"; do
        name=${f##*/}
        [[ -z ${seen[$name]:-} ]] || die "duplicate file name '$name' ($f and ${seen[$name]})"
        seen[$name]=$f
    done

    for f in "$@"; do
        name=${f##*/}
        metaflac --list --block-type=VORBIS_COMMENT --data-format=binary -- "$f" \
            > "$tagdir/$name.vc"
        echo "saved:    $f"
    done
}

restore() {
    local tagdir=$1; shift
    local f tags missing=0

    for f in "$@"; do
        tags="$tagdir/${f##*/}.vc"
        if [[ ! -f $tags ]]; then
            echo "no saved tags for $f" >&2
            missing=1
        fi
    done
    (( missing == 0 )) || die "aborting; no files were changed"

    for f in "$@"; do
        tags="$tagdir/${f##*/}.vc"
        metaflac --remove --block-type=VORBIS_COMMENT -- "$f"
        # An empty .vc means the original file had no tag block at all.
        if [[ -s $tags ]]; then
            metaflac --append --block-number=0 -- "$f" < "$tags"
        fi
        echo "restored: $f"
    done
}

(( $# >= 3 )) || usage
command -v metaflac >/dev/null || die "metaflac not found (install the 'flac' package)"

mode=$1 tagdir=$2
shift 2

for f in "$@"; do
    [[ -f $f ]] || die "not a file: $f"
done

case $mode in
    save)    save "$tagdir" "$@" ;;
    restore) restore "$tagdir" "$@" ;;
    *)       usage ;;
esac
