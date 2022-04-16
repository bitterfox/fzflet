#!/bin/bash

path=$1
shift

query="`echo $@ | sed -r "s/^\s+//" | sed -r "s/\s+$//" | sed -r "s/\s+/ -q /g"`"

opt="--color"
if [ "$FZFLET_AG_SEARCH_HIDDEN" == "true" ]; then
   opt="$opt --hidden"
fi

if [ -z "$query" ]; then
    query="."
fi

echo "Find '${@:-.}' in $path"
ag $opt $query $path
