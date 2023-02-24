#!/bin/bash

basedir=`dirname $0`
. $basedir/../util/common.sh

. $basedir/jira_config.sh


if [ -f ~/.wip_task ] && [ -s ~/.wip_task ]; then
    cat ~/.wip_task

    task=`cat ~/.wip_task | head -n 1`
    start_time=`cat ~/.wip_task | head -n 2 | tail -n 1`
    description=`cat ~/.wip_task | head -n 3 | tail -n 1`
    start_time_str=`date -d @$start_time '+%Y-%m-%dT%H:%M:%S.000%z'`
    stop_time=`date '+%s'`
    elapsed_time=`$basedir/jira_worklog_format_elapsed_time.sh $start_time $stop_time`

    echo "$task,$elapsed_time"
    mv ~/.wip_task ~/.wip_task.bak
    echo "$start_time,$stop_time,$task,$description" >> ~/.jira.worklog

    if [ -f "$FZFLET_JIRA_GO_JIRA_PATH" ]; then
        $basedir/jira_login.sh > /dev/null
        $FZFLET_JIRA_GO_JIRA_PATH -e $FZFLET_JIRA_URL -u $FZFLET_JIRA_USER view --gjq="fields.summary" $task
        $FZFLET_JIRA_GO_JIRA_PATH -e $FZFLET_JIRA_URL -u $FZFLET_JIRA_USER worklog add -T "'$elapsed_time'" -S $start_time_str --noedit $task
    fi
fi

