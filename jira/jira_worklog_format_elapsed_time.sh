#!/bin/bash

start_time="$1"
current_time=`date '+%s'`
elapsed_time_sec="$((current_time - start_time))"

elapsed_time_minute=$((elapsed_time_sec / 60))
elapsed_time_hour=$((elapsed_time_minute / 60))
if [ "$elapsed_time_hour" != "0" ]; then
    elapsed_time_minute=$((elapsed_time_minute % 60))
fi

elapsed_time_day=$((elapsed_time_hour / 24))
if [ "$elapsed_time_day" != "0" ]; then
    elapsed_time_hour=$((elapsed_time_hour % 24))
fi

elapsed_time_str=""
if [ $elapsed_time_day -ne 0 ]; then
    elapsed_time_str="${elapsed_time_day}d"
fi
if [ $elapsed_time_hour -ne 0 ]; then
    if [ -n "$elapsed_time_str" ]; then
        elapsed_time_str="$elapsed_time_str "
    fi
    elapsed_time_str="$elapsed_time_str${elapsed_time_hour}h"
fi
if [ $elapsed_time_minute -ne 0 ]; then
    if [ -n "$elapsed_time_str" ]; then
        elapsed_time_str="$elapsed_time_str "
    fi
    elapsed_time_str="$elapsed_time_str${elapsed_time_minute}m"
fi
if [ $elapsed_time_sec -lt 60 ]; then
    elapsed_time_str="1m"
fi

echo "$elapsed_time_str"
