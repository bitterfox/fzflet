#!/bin/bash

basedir=`dirname $0`

path=$1
query=$2
shift

$basedir/files_find.sh "$path" | fzf -m "$@" --query="$2"
