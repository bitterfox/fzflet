#!/bin/bash

basedir=`dirname $0`

path="$1"

if [ -f "$path" ]; then
    echo "File"
    $basedir/cat.sh "$path"
elif [ -d "$path" ]; then
    echo "Dir"
    $basedir/tree.sh "$path"
fi

