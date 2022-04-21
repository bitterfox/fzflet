#!/bin/bash

basedir=`dirname $0`

path=$1
shift
query=$1
shift

$basedir/files_find.sh "$path" | fzf -m "$@" --query="$query"
