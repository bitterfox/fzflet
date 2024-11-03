#!/bin/bash

basedir=`dirname $0`
. $basedir/../util/common.sh

. $basedir/jira_config.sh

$basedir/jira_worklog_stop_task.sh

task=$1
start_time=`date '+%s'`

echo "$task" > ~/.wip_task
echo "$start_time" >> ~/.wip_task

if [ -f "$FZFLET_JIRA_GO_JIRA_PATH" ]; then
    $basedir/jira_login.sh > /dev/null

    $FZFLET_JIRA_GO_JIRA_PATH -e $FZFLET_JIRA_URL view --gjq="fields.summary" $task >> ~/.wip_task
fi
