#!/bin/bash

basedir=`dirname $0`

. $basedir/../util/common.sh

FZF_DEFAULT_OPTS="--reverse --height ${FZF_TMUX_HEIGHT:-96%} $FZF_DEFAULT_OPTS"
$basedir/ag_reload.sh 2>/dev/null |
    $(__fzfcmd) -d : \
                --bind "change:reload($basedir/ag_reload.sh {q})" \
                --preview "$basedir/../preview/cat.sh {1} {2}" \
                --preview-window down:+{2}-/2 \
                --disabled -m "$@"
