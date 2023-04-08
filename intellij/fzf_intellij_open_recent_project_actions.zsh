#!/bin/zsh

fzflet_intellij_actions_path="$0"
fzflet_intellij_basedir() {
    dirname $fzflet_intellij_actions_path
}


INTELLIJ_CATEGORY=400

fzf_intellij_category_name() {
    echo "IntelliJ"
}

fzf_intellij_cd_recent_project_action() {
    . $(fzflet_intellij_basedir)/../util/common.sh
    load_config

    priority=$1
    description=$2

    matches=`$(fzflet_intellij_basedir)/fzf_intellij_recent_projects.sh`

    if [ $? -eq 0 ]; then
        echo "$matches" | while read line; do
            if [ -n "$line" ]; then
                cd $line
                zle fzf-redraw-prompt
            fi
        done
    fi
}

fzf_intellij_cd_recent_project_action_category_name() {
    fzf_intellij_category_name
}

fzf_intellij_cd_recent_project_action_priorities() {
    echo $INTELLIJ_CATEGORY
}

fzf_intellij_cd_recent_project_action_descriptions() {
    if [ -d "$HOME/.config/JetBrains" ]; then
        echo "Go to recent project"
    fi
}

fzf_intellij_open_recent_project_action() {
    . $(fzflet_intellij_basedir)/../util/common.sh
    load_config

    priority=$1
    description=$2

    matches=`$(fzflet_intellij_basedir)/fzf_intellij_recent_projects.sh`

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
    if [ -n "$FZFLET_INTELLIJ_EXEC_PATH" ]; then
        echo $((INTELLIJ_CATEGORY + 10))
    fi
}

fzf_intellij_open_recent_project_action_descriptions() {
    if  [ -d "$HOME/.config/JetBrains" ] && [ -n "$FZFLET_INTELLIJ_EXEC_PATH" ]; then
        echo "Open recent project"
    fi
}
