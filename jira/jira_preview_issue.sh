#!/bin/bash

basedir=`dirname $0`

ticket=$1

if [ -f "$FZFLET_JIRA_GO_JIRA_PATH" ]; then
    $basedir/jira_login.sh > /dev/null
    $FZFLET_JIRA_GO_JIRA_PATH -e $FZFLET_JIRA_URL -u $FZFLET_JIRA_USER view $ticket
fi
