#!/bin/zsh

basedir=`dirname $0`

query=$1

$basedir/zsh_history.sh | fzf \
                          --with-nth=2.. \
                          --tiebreak=index \
                          --print-query \
                          --query=$query \
                          --bind "ctrl-c:print-query" \
                          --bind "ctrl-i:replace-query"
