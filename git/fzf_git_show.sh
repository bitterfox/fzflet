#!/bin/bash

basedir=`dirname $0`

revision=$1

fzf_git_show() {
    git diff-tree -r $revision | tail -n +2 |
        fzf --with-nth=5.. --preview-window down:50%:wrap \
            --preview "if [ {5} = 'D' ]; then echo {6} is deleted; else git show -v --color=always $revision {6}; fi" \
            --bind "alt-g:execute-and-exit-on-success($basedir/fzf_git_gr.sh HEAD {6})" \
            --bind "alt-b:execute-and-exit-on-success($basedir/fzf_git_blame.sh {6})"
}

fzf_git_show
