#!/bin/bash

BASE_DIR=`dirname $0`

branch="${1:-HEAD}"
path="$2"

fzf_git_gr() {
    git log --graph --date=short --decorate=short --pretty=format:'%Cgreen%h %Creset%cd %Cblue%cn %Cred%d %Creset%s' --color $branch $path |
        fzf --no-sort \
            --preview "echo {} | sed -r 's/[^a-z0-9]*([a-z0-9]+)[^a-z0-9].*/\1/' | xargs git show -v --color" \
            --bind "alt-s:execute-and-exit-on-success($BASE_DIR/fzf_git_parse_gr_line_and_execute.sh {} $BASE_DIR/fzf_git_show.sh && echo execute-and-exit-on-success)" \
            --bind "alt-b:execute-and-exit-on-success($BASE_DIR/fzf_git_parse_gr_line_and_execute.sh {} '$BASE_DIR/fzf_git_blame.sh $path' && echo execute-and-exit-on-success)"
}

result=`fzf_git_gr`

exitCode=$?

if [ $exitCode -eq 0 ]; then
    last_line=`echo "$result" | tail -n 1`
    if [ "$last_line" == "execute-and-exit-on-success" ]; then
        # Skip last line
        echo "$result" | head -n -1
    elif [ -n "`echo "$result" | grep '\*'`" ]; then
            echo "$result" | sed -r 's/[^a-z0-9]*([a-z0-9]+)[^a-z0-9].*/\1/'
        fi
    fi
exit $exitCode
