#!/bin/bash

basedir=`dirname $0`
. $basedir/../util/common.sh

. $basedir/jira_config.sh

issue=`$basedir/fzf_jira_list_issues.sh`

if [ -n "$issue" ]; then
    $basedir/jira_worklog_start_task.sh $issue
fi
