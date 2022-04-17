#!/bin/zsh

basedir=`dirname $0`

query=$1

$basedir/zsh_history.sh | fzf \
                          --tiebreak=index \
                          --print-query \
                          --query=$query \
                          --with-nth=2.. \
                          --bind "ctrl-c:print-query" \
                          --bind "ctrl-i:replace-query"
