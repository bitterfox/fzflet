#!/bin/bash

basedir=`dirname $0`

path="${1:-.}"
shift

. $basedir/../util/common.sh
load_config

FZF_DEFAULT_OPTS="--reverse --height ${FZF_TMUX_HEIGHT:-96%} $FZF_DEFAULT_OPTS"
$basedir/ag_reload.sh $path 2>/dev/null |
    $(__fzfcmd) -d : \
                --header-lines=1 \
                --prompt "Ag: " \
                --bind "change:reload($basedir/ag_reload.sh $path {q})" \
                --bind 'ctrl-r:clear-query+toggle-search+toggle-reload+toggle-prompt(Fzf: )' \
                --bind "ctrl-o:execute-silent($FZFLET_AG_OPEN_EDITOR)" \
                --bind "alt-o:execute-silent($FZFLET_AG_OPEN_IDE)" \
                --preview "$basedir/../preview/cat.sh {1} {2}" \
                --preview-window down:+{2}-/2 \
                --disabled -m "$@"
