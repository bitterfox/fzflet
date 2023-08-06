#!/bin/bash

basedir=`dirname $0`

cache_dir=`clipctl cache-dir`

$basedir/clipmenu_ag.sh 2>/dev/null \
    | fzf --delimiter=: \
          --tiebreak=index \
          --disabled \
          --bind "change:reload($basedir/clipmenu_ag.sh {q})" \
          --preview "$basedir/../preview/cat.sh $cache_dir/{1}" \
          --preview-window down:30%:wrap \
    | awk -F: '{print $1}'
