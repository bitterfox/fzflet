#!/bin/zsh

fzflet_git_actions_path="$0"
fzflet_git_basedir() {
    dirname $fzflet_git_actions_path
}

GIT_CATEGORY=200

fzf_git_category_name() {
    git rev-parse --git-dir > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Git"
    fi
}

fzf_git_st_action() {
    . $(fzflet_git_basedir)/../util/common.sh
    load_config

    priority=$1
    description=$2

    matches=`$(fzflet_git_basedir)/fzf_git_status.sh`

    if [ $? -eq 0 ]; then
        echo "$matches" | while read line; do
            LBUFFER="${LBUFFER}${line} "
        done
    fi
}

fzf_git_st_action_category_name() {
    fzf_git_category_name
}

fzf_git_st_action_priorities() {
    echo $GIT_CATEGORY
}

fzf_git_st_action_descriptions() {
    echo "Status"
}

fzf_git_add_action() {
    . $(fzflet_git_basedir)/../util/common.sh
    load_config

    priority=$1
    description=$2

    matches=`$(fzflet_git_basedir)/fzf_git_status.sh`

    if [ $? -eq 0 ]; then
        echo "$matches" | while read line; do
            git add $line
        done
    fi
}

fzf_git_add_action_category_name() {
    fzf_git_category_name
}

fzf_git_add_action_priorities() {
    echo $((GIT_CATEGORY+1))
}

fzf_git_add_action_descriptions() {
    echo "Add"
}

fzf_git_gr_action() {
    . $(fzflet_git_basedir)/../util/common.sh
    load_config

    priority=$1
    description=$2

    matches=`$(fzflet_git_basedir)/fzf_git_gr.sh`

    if [ $? -eq 0 ]; then
        echo "$matches" | while read line; do
            LBUFFER="${LBUFFER}${line} "
        done
    fi
}

fzf_git_gr_action_category_name() {
    fzf_git_category_name
}

fzf_git_gr_action_priorities() {
    echo $((GIT_CATEGORY + 10))
}

fzf_git_gr_action_descriptions() {
    echo "Graph"
}

fzf_git_branch_action() {
    . $(fzflet_git_basedir)/../util/common.sh
    load_config

    priority=$1
    description=$2

    matches=`$(fzflet_git_basedir)/fzf_git_branch.sh`

    if [ $? -eq 0 ]; then
        echo "$matches" | while read line; do
            LBUFFER="${LBUFFER}${line}"
        done
    fi
}

fzf_git_branch_action_category_name() {
    fzf_git_category_name
}

fzf_git_branch_action_priorities() {
    echo $((GIT_CATEGORY + 20))
}

fzf_git_branch_action_descriptions() {
    echo "Branch"
}
