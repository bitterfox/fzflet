#!/bin/bash

basedir=`dirname $0`
. $basedir/gh_config.sh

FZF_DEFAULT_COMMAND="$basedir/gh_inbox.sh" \
                   fzf --preview-window down:50%:wrap \
                   --delimiter "\t" \
                   --preview "$basedir/gh_preview_inbox.sh {1}" \
                   --with-nth=2.. \
                   --bind "ctrl-r:reload($basedir/gh_inbox.sh)" \
                   --bind "ctrl-o:execute-silent($basedir/gh_open_inbox.sh {1})"
