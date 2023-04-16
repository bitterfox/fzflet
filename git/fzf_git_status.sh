#!/bin/bash

basedir=`dirname $0`

fzf_git_status() {
    git -c color.status=always status -s $@ |
        fzf -m --preview "$basedir/git_status_preview.sh {}" \
            --bind "alt-i:execute($basedir/git_status_add_i.sh {})+reload(git status -s $@)" |
        cut -c 4-
}

fzf_git_status $@ < /dev/tty
