#!/bin/zsh

fzflet_jira_basedir=`dirname $0`

JIRA_CATEGORY=500

fzf_jira_category_name() {
    echo "Jira"
}

fzf_jira_list_issues_action() {
    priority=$1
    description=$2

    . $fzflet_jira_basedir/../util/common.sh
    load_config zsh

    id=$((priority - JIRA_CATEGORY + 1))
    context=${FZFLET_JIRA_ACTIONS[$id]}

    matches=`FZFLET_JIRA_CONTEXT=$context $fzflet_jira_basedir/fzf_jira_list_issues.sh < /dev/tty`

    if [ $? -eq 0 ]; then
        echo "$matches" | while read line; do
            LBUFFER="${LBUFFER}${line}"
        done
    fi
}

fzf_jira_list_issues_action_category_name() {
    . $fzflet_jira_basedir/../util/common.sh
    load_config zsh
    for context in $FZFLET_JIRA_ACTIONS; do
        fzf_jira_category_name
    done
}

fzf_jira_list_issues_action_priorities() {
    . $fzflet_jira_basedir/../util/common.sh
    load_config zsh

    i=0
    for context in $FZFLET_JIRA_ACTIONS; do
        echo $((JIRA_CATEGORY + i))
        i=$((i + 1))
    done
}

fzf_jira_list_issues_action_descriptions() {
    . $fzflet_jira_basedir/../util/common.sh
    load_config
    load_config zsh

    for context in $FZFLET_JIRA_ACTIONS; do
        name=$(eval echo "\${FZFLET_JIRA_${context}_NAME:-}")
        url=$(eval echo "\${FZFLET_JIRA_${context}_URL:-}")
        if [ -n "$url" ]; then
            echo "${name:-$url}: List issues"
        fi
    done
}
