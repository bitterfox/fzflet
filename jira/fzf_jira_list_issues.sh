#!/bin/bash

basedir=`dirname $0`
. $basedir/../util/common.sh

. $basedir/jira_config.sh


fzf_jira_list_issues() {
    option="-m"
    if [ -f "$FZFLET_JIRA_GO_JIRA_PATH" ]; then
        option="$option"$'\t'"--preview"$'\t'"$basedir/jira_preview_issue.sh {1}"
    fi
    IFS=$'\t'
    FZF_DEFAULT_COMMAND=$basedir/jira_list_issues.sh \
        fzf $option \
        --bind "ctrl-o:execute-silent(xdg-open $FZFLET_JIRA_URL/browse/{1})" \
        --expect enter,alt-m
        # --bind "ctrl-l:execute-and-exit-on-success($FZFLET_JIRA_PREVIEW | less < /dev/tty > /dev/tty)" \
        # --bind "ctrl-g:reload(echo)+abort"
}

matches=`fzf_jira_list_issues`

if [ $? -eq 0 ]; then
    key=`echo "$matches" | head -n 1`
    lines=`echo "$matches" | tail -n +2`

    case "$key" in
        "enter" ) echo "$lines" | awk '{print $1}' ;;
        "alt-m" ) echo "$lines" ;;
    esac
fi
