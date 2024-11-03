#!/bin/bash

if [ ${FZFLET_JIRA_CONFIG:-0} -eq 0 ]; then
    basedir=`dirname $0`
    . $basedir/../util/common.sh

    . $basedir/default.rc
    load_config

    export FZFLET_JIRA_CONTEXT=${FZFLET_JIRA_CONTEXT:-${FZFLET_JIRA_DEFAULT_CONTEXT:-DEFAULT}}

    export FZFLET_JIRA_FAST_BATCH_SIZE=${FZFLET_JIRA_FAST_BATCH_SIZE:-$(eval echo "\${FZFLET_JIRA_${FZFLET_JIRA_CONTEXT}_FAST_BATCH_SIZE:-50}")}
    export FZFLET_JIRA_BATCH_SIZE=${FZFLET_JIRA_BATCH_SIZE:-$(eval echo "\${FZFLET_JIRA_${FZFLET_JIRA_CONTEXT}_BATCH_SIZE:-200}")}

    url=${FZFLET_JIRA_URL:-$(eval echo "\${FZFLET_JIRA_${FZFLET_JIRA_CONTEXT}_URL}")}
    while [ -z "$url" ]; do
        if [ "$FZFLET_JIRA_SKIP_PROMPT" == "true" ]; then
            exit 1
        fi

        echo -n "Input url> "
        read url

        if [ $? -ne 0 ]; then
            exit 1
        fi
    done
    export FZFLET_JIRA_URL=$url

    if [ -n "${FZFLET_JIRA_TOKEN+1}" ]; then
        token=$FZFLET_JIRA_TOKEN
    else
        token=$(eval echo "\${FZFLET_JIRA_${FZFLET_JIRA_CONTEXT}_TOKEN}")
    fi
    if [ -n "$token" ]; then
        export FZFLET_JIRA_TOKEN=$token
        export JIRA_API_TOKEN=$token
    else
        if [ -n "${FZFLET_JIRA_USER+1}" ]; then
            user=$FZFLET_JIRA_USER
        else
            user=$(eval echo "\${FZFLET_JIRA_${FZFLET_JIRA_CONTEXT}_USER}")
        fi
        while [ -z "$user" ]; do
            if [ "$FZFLET_JIRA_SKIP_PROMPT" == "true" ]; then
                exit 1
            fi

            echo -n "Input username for $url> "
            read user

            if [ $? -ne 0 ]; then
                exit 1
            fi
        done
        export FZFLET_JIRA_USER=$user

        if [ -n "${FZFLET_JIRA_PASSWORD+1}" ]; then
            password=$FZFLET_JIRA_PASSWORD
        else
            password=$(eval echo "\${FZFLET_JIRA_${FZFLET_JIRA_CONTEXT}_PASSWORD}")
        fi
        while [ -z "$password" ]; do
            if [ "$FZFLET_JIRA_SKIP_PROMPT" == "true" ]; then
                exit 1
            fi

            echo -n "Input password for $url> "
            read -s password

            if [ $? -ne 0 ]; then
                exit 1
            fi
        done
        export FZFLET_JIRA_PASSWORD=$password
    fi

    query_template=${FZFLET_JIRA_QUERY:-$(eval echo "\${FZFLET_JIRA_${FZFLET_JIRA_CONTEXT}_QUERY:-'assignee=${FZFLET_JIRA_USER}%20ORDER%20BY%20updated%20DESC'}")}
    export FZFLET_JIRA_QUERY=`envsubst <<< $query_template`
    go_jira_path_template=${FZFLET_JIRA_GO_JIRA_PATH:-$(eval echo "\${FZFLET_JIRA_${FZFLET_JIRA_CONTEXT}_GO_JIRA_PATH:-"$HOME/go/bin/jira"}")}
    export FZFLET_JIRA_GO_JIRA_PATH=`envsubst <<< $go_jira_path_template`

    export FZFLET_JIRA_CONFIG=1
fi
