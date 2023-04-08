#!/bin/bash

if [ -f ~/.wip_task ] && [ -s ~/.wip_task ]; then
    basedir=`dirname $0`
    . $basedir/../util/common.sh

    . $basedir/jira_config.sh

    task=`cat ~/.wip_task | head -n 1`
    start_time=`cat ~/.wip_task | head -n 2 | tail -n 1`
    elapsed_time=`$basedir/jira_worklog_format_elapsed_time.sh $start_time`

    summary=`cat ~/.wip_task | head -n 3 | tail -n 1`

    if [ -n "$summary" ]; then
        echo "$task $summary ($elapsed_time)"
    else
        echo "$task ($elapsed_time)"
    fi
fi
