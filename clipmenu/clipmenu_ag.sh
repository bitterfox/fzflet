#!/bin/bash

cache_dir=`clipctl cache-dir`

cd $cache_dir

ag_and() {
    query="$1"
    shift
    if [ $# -eq 0 ]; then
        xargs ag -l $query
    else
        xargs ag -l $query | ag_and $@
    fi
}

ag_query() {
    query="$1"
    shift
    if [ $# -eq 0 ]; then
        echo "$query"
    else
        echo "$query|`ag_query $@`"
    fi
}

if [[ "$@" == "" ]]; then
    set -- .
fi

ag_color_opts="--color"
if [[ "$@" == "." ]]; then
    ag_color_opts="$ag_color_opts --color-match=0;0"
fi


cat $cache_dir/line_cache | \
    sort -rnk 1 | awk '{print $2}' | awk '!seen[$0]++' | \
    ag_and $@ | \
    xargs ag -A10 -B10 $ag_color_opts \
          `ag_query $@`
