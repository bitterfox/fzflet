#!/bin/bash

basedir=`dirname $0`
. $basedir/gh_config.sh

FZF_DEFAULT_COMMAND="$basedir/gh_search_pulls.sh $FZFLET_GITHUB_SEARCH_PULLS_REVIEW_REQUESTED_QUERY" \
                   fzf --preview-window down:50%:wrap \
                   --preview "$basedir/gh_preview_pull.sh {1} {2}" \
                   --bind "ctrl-o:execute-silent($basedir/gh_open_pull.sh {1} {2})"
