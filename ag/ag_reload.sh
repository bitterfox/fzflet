#!/bin/bash

path=$1
shift

query="`echo $@ | sed -r "s/^\s+//" | sed -r "s/\s+$//" | sed -r "s/\s+/ -q /g"`"

if [ -z "$query" ]; then
    query="."
fi

echo "Find '${@:-.}' $query in $path"
ag --color $query $path
