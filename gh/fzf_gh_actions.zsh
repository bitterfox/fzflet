#!/bin/zsh

fzflet_github_actions_path="$0"
fzflet_github_basedir() {
    dirname $fzflet_github_actions_path
}

GITHUB_CATEGORY=250

fzf_gh_category_name() {
    if [ `command -v ag` ]; then
        echo "Github"
    fi
}

fzf_gh_list_pr_action() {
    priority=$1
    description=$2

    matches=`$(fzflet_github_basedir)/fzf_gh_pr_list.sh < /dev/tty`

    if [ $? -eq 0 ]; then
        echo "$matches" | while read line; do
            LBUFFER="${LBUFFER}${line}"
        done
    fi
}

fzf_gh_list_pr_action_category_name() {
    fzf_gh_category_name
}

fzf_gh_list_pr_action_priorities() {
    echo $GITHUB_CATEGORY
}

fzf_gh_list_pr_action_descriptions() {
    git_root=`git rev-parse --git-dir 2>/dev/null`
    if [ $? -ne 0 ]; then
        return
    fi

    # Find cache
    cache_root="$git_root/fzflet"
    mkdir -p "$cache_root"
    repo_url_cache_path="$cache_root/gh_repo_url"
    url=`cat $repo_url_cache_path 2>/dev/null`
    if [ $? -ne 0 ] || [ -z "$url" ]; then
        url=`timeout 1 gh repo view --json url | jq -r '.url'`
        if [ $? -ne 0 ] || [ -z "$url" ]; then
            return
        fi
        echo "$url" > $repo_url_cache_path
    fi

    hostname=`echo $url | sed -r "s#http(s*)://([^/]+)/([^/]+)/([^/]+)#\2#"`
    owner=`echo $url | sed -r "s#http(s*)://([^/]+)/([^/]+)/([^/]+)#\3#"`
    repo=`echo $url | sed -r "s#http(s*)://([^/]+)/([^/]+)/([^/]+)#\4#"`

    echo "List pull requests(PRs) for $hostname/$owner/$repo"
}

fzf_gh_inbox_action() {
    priority=$1
    description=$2

    . $(fzflet_github_basedir)/../util/common.sh
    load_config zsh

    id=$((priority % 10 + 1))

    context=${FZFLET_GITHUB_ACTIONS[$id]}

    matches=`FZFLET_GITHUB_CONTEXT=$context $(fzflet_github_basedir)/fzf_gh_inbox.sh < /dev/tty`

    if [ $? -eq 0 ]; then
        echo "$matches" | while read line; do
            LBUFFER="${LBUFFER}${line}"
        done
    fi
}

fzf_gh_inbox_action_category_name() {
    . $(fzflet_github_basedir)/../util/common.sh
    load_config
    load_config zsh

    for context in $FZFLET_GITHUB_ACTIONS; do
        fzf_gh_category_name
    done
}

fzf_gh_inbox_action_priorities() {
    . $(fzflet_github_basedir)/../util/common.sh
    load_config
    load_config zsh

    i=0
    for context in $FZFLET_GITHUB_ACTIONS; do
        echo $((GITHUB_CATEGORY + 10 + i))
        i=$((i + 1))
    done
}

fzf_gh_inbox_action_descriptions() {
    . $(fzflet_github_basedir)/../util/common.sh
    load_config
    load_config zsh

    for context in $FZFLET_GITHUB_ACTIONS; do
        name=$(eval echo "\${FZFLET_GITHUB_${context}_NAME:-}")
        url=$(eval echo "\${FZFLET_GITHUB_${context}_URL:-}")
        echo "${name:-$url}: Inbox"
    done
}

__fzf_gh_search_pulls_action() {
    priority=$1
    description=$2

    . $(fzflet_github_basedir)/../util/common.sh
    load_config
    load_config zsh

    id=$((priority - GITHUB_CATEGORY - 30))
    j=$((id % 10))
    id=$((id / 10 + 1))

    context=${FZFLET_GITHUB_ACTIONS[$id]}

    query_name=$(eval echo "\${FZFLET_GITHUB_${context}_SEARCH_PULLS_QUERY_${j}_NAME:-}")
    query=$(eval echo "\${FZFLET_GITHUB_${context}_SEARCH_PULLS_QUERY_${j}:-}")

    FZFLET_GITHUB_CONTEXT=$context $(fzflet_github_basedir)/fzf_gh_search_pulls.sh $query < /dev/tty
}

fzf_gh_search_pulls_action() {
    matches=`__fzf_gh_search_pulls_action $1 $2`

    if [ $? -eq 0 ]; then
        echo "$matches" | while read line; do
            LBUFFER="${LBUFFER}${line}"
        done
    fi
}

fzf_gh_search_pulls_action_category_name() {
    . $(fzflet_github_basedir)/../util/common.sh
    load_config
    load_config zsh
    i=0
    for context in $FZFLET_GITHUB_ACTIONS; do
        j=1
        while :; do
            query_name=$(eval echo "\${FZFLET_GITHUB_${context}_SEARCH_PULLS_QUERY_${j}_NAME:-}")
            if [ -z "$query_name" ]; then
                break;
            fi
            fzf_gh_category_name
            j=$((j + 1))
        done
        i=$((i + 1))
    done
}

fzf_gh_search_pulls_action_priorities() {
    . $(fzflet_github_basedir)/../util/common.sh
    load_config
    load_config zsh

    i=0
    for context in $FZFLET_GITHUB_ACTIONS; do
        j=1
        while :; do
            query_name=$(eval echo "\${FZFLET_GITHUB_${context}_SEARCH_PULLS_QUERY_${j}_NAME:-}")
            if [ -z "$query_name" ]; then
                break;
            fi
            echo $((GITHUB_CATEGORY + 30 + i * 10 + j))
            j=$((j + 1))
        done
        i=$((i + 1))
    done
}

fzf_gh_search_pulls_action_descriptions() {
    . $(fzflet_github_basedir)/../util/common.sh
    load_config
    load_config zsh

    i=0
    for context in $FZFLET_GITHUB_ACTIONS; do
        name=$(eval echo "\${FZFLET_GITHUB_${context}_NAME:-}")
        url=$(eval echo "\${FZFLET_GITHUB_${context}_URL:-}")
        j=1
        while :; do
            query_name=$(eval echo "\${FZFLET_GITHUB_${context}_SEARCH_PULLS_QUERY_${j}_NAME:-}")
            if [ -z "$query_name" ]; then
                break;
            fi
            echo "${name:-$url}: Search my pull requests(PRs) $query_name"
            j=$((j + 1))
        done
        i=$((i + 1))
    done
}
