#!/bin/bash

basedir=`dirname $0`

path="$1"
revision="${2:-HEAD}"

git_blame() {
    path=$1
    revision=$2

    tmppath="/tmp/fzf_git_blame/`basename $path`"
    mkdir -p `dirname $tmppath`
    git show $revision:$path > $tmppath

    while read -r a && read -r b <&3; do
        blame_info=`echo "$a" | sed -r "s/(^[0-9a-f]+ \([^)]*\)).*/\1/"`
        echo "$blame_info $b"
    done < <(git blame $path $revision) 3< <(batcat -p --color=always $tmppath)
    rm $tmppath
}

fzf_git_blame() {
    git_blame $path $revision |
        fzf \
            --nth=8.. --no-sort --preview-window down:50%:wrap --preview 'git show -v --color=always {1}' \
            --bind "alt-g:execute-and-exit-on-success($basedir/fzf_git_gr.sh {1} $path && echo execute-and-exit-on-success)" \
            --bind "alt-s:execute-and-exit-on-success($basedir/fzf_git_show.sh {1} $path && echo execute-and-exit-on-success)" \
            --bind "alt-c:execute-and-exit-on-success($basedir/fzf_git_blame.sh $path {1}~ && echo execute-and-exit-on-success)"
}



if [ -n "$path" ]; then
    result=`fzf_git_blame`
else
    pwd=`pwd`
    result=`find $pwd | fzf --header "Paths" \
       --bind "enter:execute-and-exit-on-success($0 {})"`
fi

exitCode=$?

if [ $exitCode -eq 0 ]; then
    last_line=`echo "$result" | tail -n 1`
    if [ "$last_line" == "execute-and-exit-on-success" ]; then
        # Skip last line
        echo "$result" | head -n -1
    else
        echo "$result" | awk '{print $1}'
    fi
fi

exit $exitCode
