#!/bin/zsh

fzflet_intellij_basedir=`dirname $0`

INTELLIJ_CATEGORY=300

fzf_intellij_category_name() {
    echo "IntelliJ"
}

fzf_intellij_cd_recent_project_action() {
    . $fzflet_intellij_basedir/../util/common.sh
    load_config

    priority=$1
    description=$2

    matches=`$fzflet_intellij_basedir/fzf_intellij_recent_projects.sh`

    if [ $? -eq 0 ]; then
        echo "$matches" | while read line; do
            cd $line
            zle fzf-redraw-prompt
        done
    fi
}

fzf_intellij_cd_recent_project_action_category_name() {
    fzf_intellij_category_name
}

fzf_intellij_cd_recent_project_action_priorities() {
    . $fzflet_intellij_basedir/../util/common.sh
    load_config
    echo $INTELLIJ_CATEGORY
}

fzf_intellij_cd_recent_project_action_descriptions() {
    . $fzflet_intellij_basedir/../util/common.sh
    load_config
    echo "Go to recent project"
}

fzf_intellij_open_recent_project_action() {
    . $fzflet_intellij_basedir/../util/common.sh
    load_config

    priority=$1
    description=$2

    matches=`$fzflet_intellij_basedir/fzf_intellij_recent_projects.sh`

    if [ $? -eq 0 ]; then
        echo "$matches" | while read line; do
            nohup $FZFLET_INTELLIJ_EXEC_PATH $line > /dev/null 2>&1 &
        done
    fi
}

fzf_intellij_open_recent_project_action_category_name() {
    fzf_intellij_category_name
}

fzf_intellij_open_recent_project_action_priorities() {
    . $fzflet_intellij_basedir/../util/common.sh
    load_config
    if [ -n "$FZFLET_INTELLIJ_EXEC_PATH" ]; then
        echo $((INTELLIJ_CATEGORY + 10))
    fi
}

fzf_intellij_open_recent_project_action_descriptions() {
    . $fzflet_intellij_basedir/../util/common.sh
    load_config
    if [ -n "$FZFLET_INTELLIJ_EXEC_PATH" ]; then
        echo "Open recent project"
    fi
}
