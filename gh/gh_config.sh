#!/bin/bash

if [ ${FZFLET_GITHUB_CONFIG:-0} -eq 0 ]; then
    basedir=`dirname $0`
    . $basedir/../util/common.sh

    . $basedir/default.rc
    load_config

    export FZFLET_GITHUB_CONTEXT=${FZFLET_GITHUB_CONTEXT:-${FZFLET_GITHUB_DEFAULT_CONTEXT:-DEFAULT}}

    export FZFLET_GITHUB_NAME=${FZFLET_GITHUB_NAME:-$(eval echo "\${FZFLET_GITHUB_${FZFLET_GITHUB_CONTEXT}_NAME}")}

    hostname=${FZFLET_GITHUB_HOSTNAME:-$(eval echo "\${FZFLET_GITHUB_${FZFLET_GITHUB_CONTEXT}_HOSTNAME}")}
    while [ -z "$hostname" ]; do
        echo -n "Input hostname> "
        read hostname

        if [ $? -ne 0 ]; then
            exit 1
        fi
    done
    export FZFLET_GITHUB_HOSTNAME=$hostname

    if [ -n "${FZFLET_GITHUB_USER+1}" ]; then
        user=$FZFLET_GITHUB_USER
    else
        user=$(eval echo "\${FZFLET_GITHUB_${FZFLET_GITHUB_CONTEXT}_USER}")
    fi
    if [ -z "$user" ] && [ `command -v gh` ]; then
        user="`gh api --hostname $FZFLET_GITHUB_HOSTNAME /user -q .login`"
    fi

    while [ -z "$user" ]; do
        echo -n "Input username for $hostname> "
        read user

        if [ $? -ne 0 ]; then
            exit 1
        fi
    done
    export FZFLET_GITHUB_USER=$user

    export FZFLET_GITHUB_SEARCH_PULLS_QUERY=${FZFLET_GITHUB_SEARCH_PULLS_QUERY:-$(eval echo "\${FZFLET_GITHUB_${FZFLET_GITHUB_CONTEXT}_SEARCH_PULLS_CREATED_QUERY}")}
    export FZFLET_GITHUB_SEARCH_PULLS_REVIEW_REQUESTED_QUERY=${FZFLET_GITHUB_SEARCH_PULLS_REVIEW_REQUESTED_QUERY:-$(eval echo "\${FZFLET_GITHUB_${FZFLET_GITHUB_CONTEXT}_SEARCH_PULLS_REVIEW_REQUESTED_QUERY}")}
    export FZFLET_GITHUB_SEARCH_PULLS_CREATED_QUERY=${FZFLET_GITHUB_SEARCH_PULLS_CREATED_QUERY:-$(eval echo "\${FZFLET_GITHUB_${FZFLET_GITHUB_CONTEXT}_SEARCH_PULLS_CREATED_QUERY}")}

    export FZFLET_GITHUB_DEFAULT_REPOSITORY_LENGTH_BUFFER=${FZFLET_GITHUB_REPOSITORY_LENGTH_BUFFER:-$(eval echo "\${FZFLET_GITHUB_${FZFLET_GITHUB_CONTEXT}_REPOSITORY_LENGTH_BUFFER:-5}")}
    export FZFLET_GITHUB_DEFAULT_NUMBER_LENGTH_BUFFER=${FZFLET_GITHUB_NUMBER_LENGTH_BUFFER:-$(eval echo "\${FZFLET_GITHUB_${FZFLET_GITHUB_CONTEXT}_NUMBER_LENGTH_BUFFER:-1}")}
    export FZFLET_GITHUB_DEFAULT_TITLE_LENGTH_BUFFER=${FZFLET_GITHUB_TITLE_LENGTH_BUFFER:-$(eval echo "\${FZFLET_GITHUB_${FZFLET_GITHUB_CONTEXT}_TITLE_LENGTH_BUFFER:-5}")}
    export FZFLET_GITHUB_DEFAULT_USER_LENGTH_BUFFER=${FZFLET_GITHUB_USER_LENGTH_BUFFER:-$(eval echo "\${FZFLET_GITHUB_${FZFLET_GITHUB_CONTEXT}_USER_LENGTH_BUFFER:-5}")}

    export FZFLET_GITHUB_CONFIG=1
fi
