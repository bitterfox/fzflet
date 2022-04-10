#!/bin/bash

BASE_DIR=`dirname $0`

fzf_git_branch() {
    max_branch_width=`git branch --format="%(refname:short)" | awk '{ print length, $0}' | sort -n -s -r | head -n 1 | awk '{print $1}'`
    width=$((max_branch_width + 2))
    max_authorname_width=`git branch --format="%(authorname)" | awk '{ print length, $0}' | sort -n -s -r | head -n 1 | awk '{print $1}'`
    git branch --sort=-committerdate --format="%(color:red)%(HEAD)%(color:reset) %(align:width=$width)%(refname:short)%(end) %(authordate:format-local:%Y/%m/%d %H:%M:%S) %(color:green)%(objectname:short)%(color:reset) %(color:blue)%(align:width=$max_authorname_width)%(authorname)%(end)%(color:reset) %(if) %(upstream:short) %(then) %(color:red)(%(upstream:short))%(color:reset)%(end) %(contents:subject)" --color |
        fzf \
            --no-sort --preview-window down:50%:wrap --preview "$BASE_DIR/fzf_git_parse_branch_line_and_execute.sh {} 'git show -v --color=always'" \
            --bind "alt-g:execute-and-exit-on-success($BASE_DIR/fzf_git_parse_branch_line_and_execute.sh {} $BASE_DIR/fzf_git_gr.sh && echo execute-and-exit-on-success)" \
            --bind "alt-s:execute-and-exit-on-success($BASE_DIR/fzf_git_parse_branch_line_and_execute.sh {} $BASE_DIR/fzf_git_show.sh && echo execute-and-exit-on-success)"
}

result=`fzf_git_branch`

exitCode=$?

if [ $exitCode -eq 0 ]; then
    last_line=`echo "$result" | tail -n 1`
    if [ "$last_line" == "execute-and-exit-on-success" ]; then
        # Skip last line
        echo "$result" | head -n -1
    else
        echo "$result" | cut -c 2- | awk '{print $1}'
    fi
fi

exit $exitCode
