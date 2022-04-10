#!/bin/bash

if [ ${FZFLET_JIRA_CONFIG:-0} -eq 0 ]; then
    basedir=`dirname $0`
    . $basedir/../util/common.sh

    . $basedir/default.rc
    load_config

    export FZFLET_JIRA_FAST_BATCH_SIZE=${FZFLET_JIRA_FAST_BATCH_SIZE:-${FZFLET_JIRA_DEFAULT_FAST_BATCH_SIZE:-50}}
    export FZFLET_JIRA_BATCH_SIZE=${FZFLET_JIRA_BATCH_SIZE:-${FZFLET_JIRA_DEFAULT_BATCH_SIZE:-200}}

    url=${FZFLET_JIRA_URL:-${FZFLET_JIRA_DEFAULT_URL}}
    while [ -z "$url" ]; do
        echo -n "Input url> "
        read url

        if [ $? -ne 0 ]; then
            exit 1
        fi
    done
    export FZFLET_JIRA_URL=$url

    user=${FZFLET_JIRA_USER:-${FZFLET_JIRA_DEFAULT_USER}}
    while [ -z "$user" ]; do
        echo -n "Input username for $url> "
        read user

        if [ $? -ne 0 ]; then
            exit 1
        fi
    done
    export FZFLET_JIRA_USER=$user

    password=${FZFLET_JIRA_PASSWORD:-${FZFLET_JIRA_DEFAULT_PASSWORD}}
    while [ -z "$password" ]; do
        echo -n "Input password for $url> "
        read -s password

        if [ $? -ne 0 ]; then
            exit 1
        fi
    done
    export FZFLET_JIRA_PASSWORD=$password

    export FZFLET_JIRA_QUERY=`envsubst <<< ${FZFLET_JIRA_QUERY:-${FZFLET_JIRA_DEFAULT_QUERY:-'assignee=${FZFLET_JIRA_USER}%20ORDER%20BY%20updated%20DESC'}}`
    export FZFLET_JIRA_GO_JIRA_PATH=`envsubst <<< ${FZFLET_JIRA_GO_JIRA_PATH:-${FZFLET_JIRA_DEFAULT_GO_JIRA_PATH:-"$HOME/go/bin/jira"}}`

    export FZFLET_JIRA_CONFIG=1
fi
