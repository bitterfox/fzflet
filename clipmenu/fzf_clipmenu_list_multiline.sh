#!/bin/bash

basedir=`dirname $0`

cache_dir=`clipctl cache-dir`

#    | fzf --tiebreak=index \
#          --with-nth=2.. \
#          --preview "$basedir/../preview/cat.sh $cache_dir/{1}" \
#          --preview-window down:30% \
$basedir/clipmenu_list_multiline.sh . \
    | fzf --with-nth=2.. --read0 --gap \
    | head -n 1 \
    | awk '{print $1}'
