#!/bin/bash

__fzf_use_tmux__() {
  [ -n "$TMUX_PANE" ] && [ "${FZF_TMUX:-0}" != 0 ] && [ ${LINES:-40} -gt 15 ]
}

__fzfcmd() {
  __fzf_use_tmux__ &&
    echo "fzf-tmux -d${FZF_TMUX_HEIGHT:-40%}" || echo "fzf"
}

cache_dir() {
    cache_dir_root="$HOME/.cache/fzflet"
    subdir="$1"

    cache_dir="$cache_dir_root/$subdir/"

    if [ ! -d $cache_dir ]; then
        mkdir -p $cache_dir
    fi

    echo "$cache_dir"
}
