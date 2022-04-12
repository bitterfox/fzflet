#!/bin/zsh

fzflet_ag_basedir=`dirname $0`

fzf_ag_widget() {
    $fzflet_ag_basedir/fzf_ag.sh |
        awk -F: '{print $1}' |
        while read item; do
            LBUFFER="${LBUFFER}${(q)item} "
        done
  local ret=$?
  zle redisplay
  return $ret
}
zle     -N   fzf_ag_widget
bindkey '^X^G' fzf_ag_widget
