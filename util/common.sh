#!/bin/bash

export FZFLET_DEFAULT_RC_PATH=$HOME/.fzflet.rc

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

rc_path() {
    echo ${FZFLET_RC_PATH:-$FZFLET_DEFAULT_RC_PATH}
}

load_config() {
    rc_path=`rc_path`
    if [ -f $rc_path ]; then
        . $rc_path
    fi
}
