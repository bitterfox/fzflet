#!/bin/bash

basedir=`dirname $0`

cache_dir=`clipctl cache-dir`

$basedir/clipmenu_list.sh . \
    | fzf --tiebreak=index \
          --with-nth=2.. \
          --preview "$basedir/../preview/cat.sh $cache_dir/{1}" \
          --preview-window down:30% \
    | awk '{print $1}'
