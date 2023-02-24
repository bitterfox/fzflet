#!/bin/bash

basedir=`dirname $0`
. $basedir/../util/common.sh

. $basedir/jira_config.sh

duration="${1:-week}"

if [ "$duration" == "daily" ]; then
    start_s=`date --date="today 00:00:00" '+%s'`
elif [ "$duration" == "weekly" ]; then
    start_s=`date --date="week ago sunday 00:00:00" '+%s'`
elif [ "$duration" == "biweekly" ]; then
    start_s=`date --date="2week ago sunday 00:00:00" '+%s'`
elif [ "$duration" == "monthly" ]; then
    first_day_of_month=`date --date="today" +"%Y-%m-01"`
    start_s=`date --date="$first_day_of_month 00:00:00" '+%s'`
else
    after=`date --date="$duration" '+%s'`
    tomorrow_beggining=`date --date="day 00:00:00" '+%s'`
    now=`date '+%s'`

    duration_s=$((after - tomorrow_beggining))
    start_s=$((now - duration_s))
fi

declare -A task_durations
declare -A task_descriptions
while read line; do
    start_time=`echo $line | awk -F, '{print $1}'`
    if [ -z "$start_time" ] || [ "$start_time" -lt "$start_s" ]; then
        break
    fi
    stop_time=`echo $line | awk -F, '{print $2}'`
    ticket=`echo $line | awk -F, '{print $3}'`
    d="${task_durations[${ticket}]}"
    if [ -z "$d" ]; then
        d=0
    fi
    task_durations[$ticket]="$((d + stop_time - start_time))"

    if [ -z "${task_descriptions[$ticket]}" ]; then
        task_descriptions[$ticket]="`echo $line | cut -d',' -f4-`"
    fi
done <<< $(tac ~/.jira.worklog)

total_duration=0
for ticket in "${!task_durations[@]}"; do
    description="${task_descriptions[$ticket]}"
    d="${task_durations[${ticket}]}"
    echo "${ticket} $description (`$basedir/jira_worklog_format_elapsed_time.sh 0 $d`)"
    total_duration=$((total_duration + d))
done
echo "Worked `$basedir/jira_worklog_format_elapsed_time.sh 0 $total_duration` from `date "-d@$start_s"`"
