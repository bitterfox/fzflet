#!/bin/bash

basedir=`dirname $0`
. $basedir/../util/common.sh

. $basedir/jira_config.sh

finish=0

current=0
batch=$FZFLET_JIRA_FAST_BATCH_SIZE

trap 'echo killing | tee /tmp/debug.script; finish=1' SIGUSR1 SIGKILL SIGINT
while [ $finish -eq 0 ]; do
    result=`curl -s -u "$FZFLET_JIRA_USER:$FZFLET_JIRA_PASSWORD" "$FZFLET_JIRA_URL/rest/api/2/search?startAt=$current&maxResult=$batch&fields=issuetype,project,summary,description,assignee&jql=$FZFLET_JIRA_QUERY"`

    if [ $? -ne 0 ]; then
        echo quit
        break
    fi

    if [ -z "`echo $result | jq '.issues[]'`" ]; then
        break
    fi

    echo $result | jq -r '.issues | map({key: .key, summary: .fields.summary}) | .[] | to_entries | map("\(.value)") | join(" ")'

    current=$((current + batch))
    batch=$FZFLET_JIRA_BATCH_SIZE
done
