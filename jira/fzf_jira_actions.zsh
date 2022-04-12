#!/bin/zsh

fzflet_jira_basedir=`dirname $0`

JIRA_CATEGORY=500

fzf_jira_category_name() {
    echo "Jira"
}

fzf_jira_list_issues_action() {
    priority=$1
    description=$2

    matches=`$fzflet_jira_basedir/fzf_jira_list_issues.sh < /dev/tty`

    if [ $? -eq 0 ]; then
        echo "$matches" | while read line; do
            LBUFFER="${LBUFFER}${line}"
        done
    fi
}

fzf_jira_list_issues_action_category_name() {
    fzf_jira_category_name
}

fzf_jira_list_issues_action_priorities() {
    . $fzflet_jira_basedir/../util/common.sh
    load_config
    if [ -n "$FZFLET_JIRA_DEFAULT_URL" ]; then
        echo $JIRA_CATEGORY
    fi
}

fzf_jira_list_issues_action_descriptions() {
    . $fzflet_jira_basedir/../util/common.sh
    load_config
    if [ -n "$FZFLET_JIRA_DEFAULT_URL" ]; then
        echo "list issues in $FZFLET_JIRA_DEFAULT_URL"
    fi
}
