#!/bin/bash

basedir=`dirname $0`

path=$1
shift
if [ $# -ge 1 ]; then
  query=$1
  shift
fi

FZFLET_FILES_FIND_TARGET="${FZFLET_FILES_FIND_TARGET:-file}"
case "$FZFLET_FILES_FIND_TARGET" in
    "file") NEXT_FZFLET_FILES_FIND_TARGET="dir" ;;
    "dir") NEXT_FZFLET_FILES_FIND_TARGET="all" ;;
    "all") NEXT_FZFLET_FILES_FIND_TARGET="file" ;;
esac

$basedir/files_find.sh "$path" | fzf --header-first --header="Finding $FZFLET_FILES_FIND_TARGET" -m "$@" --query="$query" --bind "ctrl-t:execute-and-exit-on-success(FZFLET_FILES_FIND_TARGET=$NEXT_FZFLET_FILES_FIND_TARGET $0 \"$path\" {q} || exit 0)" --preview="$basedir/../preview/preview_path.sh {}"
