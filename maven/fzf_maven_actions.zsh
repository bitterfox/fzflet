#!/bin/zsh

fzflet_maven_actions_path="$0"
fzflet_maven_basedir() {
    dirname $fzflet_maven_actions_path
}

MAVEN_CATEGORY=600

fzf_maven_category_name() {
    echo "Maven"
}

fzf_maven_search_action() {
    priority=$1
    description=$2

    . $(fzflet_maven_basedir)/../util/common.sh
    load_config zsh

    id=$((priority - MAVEN_CATEGORY + 1))
    context=${FZFLET_MAVEN_ACTIONS[$id]}

    matches=`FZFLET_MAVEN_CONTEXT=$context $(fzflet_maven_basedir)/fzf_maven_search.sh < /dev/tty`

    if [ $? -eq 0 ]; then
        echo "$matches" | while read line; do
            LBUFFER="${LBUFFER}${line}"
        done
    fi
}

fzf_maven_search_action_category_name() {
    . $(fzflet_maven_basedir)/../util/common.sh
    load_config zsh

    for context in $FZFLET_MAVEN_ACTIONS; do
            fzf_maven_category_name
    done
}

fzf_maven_search_action_priorities() {
    . $(fzflet_maven_basedir)/../util/common.sh
    load_config zsh

    i=0
    for context in $FZFLET_MAVEN_ACTIONS; do
        echo $((MAVEN_CATEGORY + i))
        i=$((i + 1))
    done
}

fzf_maven_search_action_descriptions() {
    . $(fzflet_maven_basedir)/../util/common.sh
    load_config
    load_config zsh

    for context in $FZFLET_MAVEN_ACTIONS; do
        name=$(eval echo "\${FZFLET_MAVEN_${context}_NAME:-}")
        url=$(eval echo "\${FZFLET_MAVEN_${context}_URL:-}")
        echo "${name:-$url}: Search maven artifacts"
    done
}
