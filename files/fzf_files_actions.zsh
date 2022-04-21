#!/bin/zsh

fzflet_files_basedir=`dirname $0`

FILES_CATEGORY=100

fzf_files_category_name() {
    echo "Files"
}

fzf_files_find_file_action() {
    priority=$1
    description=$2

    lbuffer_without_query="$LBUFFER"
    query=""
    if [[ "${LBUFFER: -1}" != " " ]]; then
        lbuffer_without_query="`echo "$LBUFFER" | sed -r "s/(.*\s)?(.+)/\1/"`"
        query="`echo "$LBUFFER" | sed -r "s/(.*\s)?(.+)/\2/"`"

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

    search_hidden_file="false"
    if [[ "$file" == "." ]]; then
        search_hidden_file="true"
        file=""
    fi

    matches=`FZFLET_FILES_FIND_HIDDEN=$search_hidden_file $fzflet_files_basedir/fzf_files_find.sh $dir $file`
    ret=$?

    if [ $ret -eq 0 ]; then
        files=""
        echo "$matches" | while read item; do
            if [[ "$dir" == "./" ]]; then
                p="${(q)item}"
            else
                p="$dir${(q)item}"
            fi
            if [ -d "$p" ]; then
                files="$files$p/ "
            else
                files="$files$p "
            fi
        done
        if [ -n "$files" ]; then
            LBUFFER="$lbuffer_without_query$files"
        fi
        zle fzf-redraw-prompt
    fi
}
zle     -N   fzf_files_find_file_action

if [ -n "$FZFLET_FIND_FILE_ACTION_KEY" ]; then
    bindkey "$FZFLET_FIND_FILE_ACTION_KEY" fzf_files_find_file_action
fi

fzf_files_find_file_action_category_name() {
    fzf_files_category_name
}

fzf_files_find_file_action_priorities() {
    echo $FILES_CATEGORY
}

fzf_files_find_file_action_descriptions() {
    echo "Find file"
}

fzf_files_goto_dir_action() {
    priority=$1
    description=$2

    lbuffer_without_query="$LBUFFER"
    query=""
    if [[ "${LBUFFER: -1}" != " " ]]; then
        lbuffer_without_query="`echo "$LBUFFER" | sed -r "s/(.*\s)?(.+)/\1/"`"
        query="`echo "$LBUFFER" | sed -r "s/(.*\s)?(.+)/\2/"`"

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

    search_hidden_file="false"
    if [[ "$file" == "." ]]; then
        search_hidden_file="true"
        file=""
    fi

    match=`FZFLET_FILES_FIND_DIR_ONLY="true" FZFLET_FILES_FIND_HIDDEN=$search_hidden_file $fzflet_files_basedir/fzf_files_find.sh $dir $file +m`
    ret=$?

    if [ $ret -eq 0 ]; then
        if [[ -z "$match" ]] || [[ ! -d "$dir/$match" ]]; then
            zle redisplay
            return 0
        fi

        cd "$dir/$match"
        LBUFFER="$lbuffer_without_query"
        ret=$?
        zle fzf-redraw-prompt
        typeset -f zle-line-init >/dev/null && zle zle-line-init
    fi
    return $ret
}
zle     -N   fzf_files_goto_dir_action

if [ -n "$FZFLET_GOTO_DIR_ACTION_KEY" ]; then
    bindkey "$FZFLET_GOTO_DIR_ACTION_KEY" fzf_files_goto_dir_action
fi

fzf_files_goto_dir_action_category_name() {
    fzf_files_category_name
}

fzf_files_goto_dir_action_priorities() {
    echo $((FILES_CATEGORY + 1))
}

fzf_files_goto_dir_action_descriptions() {
    echo "Go to directory"
}
