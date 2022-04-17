#!/bin/bash

# fzf_intellij_recent_projects.sh 2020.2 30

basedir=`dirname $0`

projects=`$basedir/intellij_list_recent_projects.sh $@ | sort -n -k 1 -r`

len_max=0
while read line; do
    len=${#line}
    if [ $len_max -lt $len ]; then
        len_max=$len
    fi
done <<< "$projects"

echo "$projects" | while read line; do
    timestamp=`sed -r 's/^([0-9]+)[0-9]{3}.*/\1/' <<< $line`
    time=`date -d@$timestamp 2> /dev/null`
    printf "%-${len_max}s %s\n" "`sed -r "s/[0-9]+ (.*)/\1/" <<< $line`" "$time"
done | fzf --tiebreak=index | awk '{print $1}'
