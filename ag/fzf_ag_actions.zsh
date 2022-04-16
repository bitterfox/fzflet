#!/bin/zsh

fzflet_ag_basedir=`dirname $0`

AG_CATEGORY=150

fzf_ag_category_name() {
    echo "ag"
}

fzf_ag_action() {
    priority=$1
    description=$2

    lbuffer_without_query="$LBUFFER"
    query=""
    if [[ "${LBUFFER: -1}" != " " ]]; then
        lbuffer_without_query="`echo "$LBUFFER" | sed -r "s/(.*\s)?([^\S]+)/\1/"`"
        query="`echo "$LBUFFER" | sed -r "s/(.*\s)?([^\S]+)/\2/"`"

        dir="`echo "$query" | sed -r "s/(.*)\/(.*)/\1/"`"
        if [[ "$dir" == "$query" ]]; then
            dir="./"
            file="$query"
        else
            dir="$dir/"
            file="`echo "$query" | sed -r "s/(.*)\/(.*)/\2/"`"
        fi
    else
        dir="./"
        file=""
    fi

    if [[ "$dir" == "./" ]]; then
        dir=""
    fi

    search_hidden_file="false"
    if [[ "$file" == "." ]]; then
        search_hidden_file="true"
    fi

    resolved_dir=`eval echo $dir`
    resolved_dir_len=${#resolved_dir}

    matches=`FZFLET_AG_SEARCH_HIDDEN=$search_hidden_file $fzflet_ag_basedir/fzf_ag.sh $resolved_dir`
    ret=$?

    if [ $ret -eq 0 ]; then
        files=""
        echo "$matches" | awk -F: '{print $1}' | while read line; do
            p=`echo $line | cut -b$((resolved_dir_len + 1))-`
            if [[ "$dir" == "./" ]]; then
                files="$files${(q)line} "
            else
                files="$files$dir${(q)p} "
            fi
        done
        if [ -n "$files" ]; then
            LBUFFER="$lbuffer_without_query$files"
        fi
        zle fzf-redraw-prompt
    fi

    return $ret
}
zle     -N   fzf_ag_action

if [ -n "$FZFLET_AG_ACTION_KEY" ]; then
    bindkey "$FZFLET_AG_ACTION_KEY" fzf_ag_action
fi

fzf_ag_action_category_name() {
    fzf_ag_category_name
}

fzf_ag_action_priorities() {
    echo $AG_CATEGORY
}

fzf_ag_action_descriptions() {
    echo "Find in files"
}
