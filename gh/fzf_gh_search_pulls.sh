#!/bin/bash

basedir=`dirname $0`
. $basedir/gh_config.sh

query="$1"
if [ -n "$query" ]; then
    export FZFLET_GITHUB_SEARCH_PULLS_QUERY="$query"
fi

FZF_DEFAULT_COMMAND="$basedir/gh_search_pulls.sh $FZFLET_GITHUB_SEARCH_PULLS_QUERY" \
                   fzf --preview-window down:50%:wrap \
                   --preview "$basedir/gh_preview_pull.sh {1} {2}" \
                   --bind "ctrl-o:execute-silent($basedir/gh_open_pull.sh {1} {2})"

