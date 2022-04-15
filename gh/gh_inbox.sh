#!/bin/bash

function rel_fmt_low_precision() {
    local SEC_PER_MINUTE=$((60))
    local   SEC_PER_HOUR=$((60*60))
    local    SEC_PER_DAY=$((60*60*24))
    local  SEC_PER_MONTH=$((60*60*24*30))
    local   SEC_PER_YEAR=$((60*60*24*365))

    local last_unix="$(date --date="$1" +%s)"    # convert date to unix timestamp
    local now_unix="$(date +'%s')"

    local delta_s=$(( now_unix - last_unix ))

    number=0
    unit=""
    if (( delta_s <  SEC_PER_MINUTE * 2))
    then
        number=$((delta_s))
        unit="seconds"
    elif (( delta_s <  SEC_PER_HOUR * 2))
    then
        number=$((delta_s / SEC_PER_MINUTE))
        unit="minutes"
    elif (( delta_s <  SEC_PER_DAY * 2))
    then
        number=$((delta_s / SEC_PER_HOUR))
        unit="hours"
    elif (( delta_s <  SEC_PER_MONTH * 2))
    then
        number=$((delta_s / SEC_PER_DAY))
        unit="days"
    elif (( delta_s <  SEC_PER_YEAR * 2))
    then
        number=$((delta_s / SEC_PER_MONTH))
        unit="months"
    else
        number=$((delta_s / SEC_PER_YEAR))
        unit="years"
    fi
    printf "%3d %7s ago" $number $unit
}

basedir=`dirname $0`
. $basedir/gh_config.sh

query=$1

page=1

total_repository_max_length=0
total_number_max_length=0
total_title_max_length=0
total_reason_max_length=0

while :; do
    response=`gh api --hostname $FZFLET_GITHUB_HOSTNAME "/notifications?page=$page&all=true"`

    repository_max_length=`echo $response | jq '[.[].repository.full_name | length] | max'`
    number_max_length=`echo "$response" |  jq '[.[].subject.url | capture("(?<a>.*)/(?<b>.*)") | .b | length] | max'`
    title_max_length=`echo "$response" | jq '[.[].subject.title | length] | max'`
    reason_max_length=`echo "$response" | jq '[.[].reason | length] | max'`

    if [ $total_repository_max_length -lt $repository_max_length ]; then
        total_repository_max_length=$((repository_max_length + FZFLET_GITHUB_REPOSITORY_LENGTH_BUFFER))
    fi
    if [ $total_number_max_length -lt $number_max_length ]; then
        total_number_max_length=$((number_max_length + FZFLET_GITHUB_NUMBER_LENGTH_BUFFER))
    fi
    if [ $total_title_max_length -lt $title_max_length ]; then
        total_title_max_length=$((title_max_length + FZFLET_GITHUB_TITLE_LENGTH_BUFFER))
    fi
    if [ $total_reason_max_length -lt $reason_max_length ]; then
        total_reason_max_length=$((reason_max_length + FZFLET_GITHUB_REASON_LENGTH_BUFFER))
    fi

    while read unread && read updated_at <&3 && read last_read_at <&4 && read title <&5 && read reason <&6 && read full_name <&7 && read id <&8 && read number <&9; do
        if [ "$updated_at" == "null" ]; then
            rel_updated_at="(null)"
        else
            rel_updated_at=`rel_fmt_low_precision $updated_at`
        fi
        if [ "$last_read_at" == "null" ]; then
            rel_last_read_at="(null)"
        else
            rel_last_read_at=`rel_fmt_low_precision $last_read_at`
        fi

        unread_marker=" "
        if [ "$unread" == "true" ]; then
            unread_marker="*"
        fi

        printf "%d\t%s %-${total_repository_max_length}s %-${total_number_max_length}s %-${total_title_max_length}s %${total_reason_max_length}s %s %s\n" \
               "$id" "$unread_marker" "$full_name" "#$number" "$title" "$reason" "$rel_updated_at" "$rel_last_read_at"
        # echo "$id $unread_marker $reason $rel_updated_at $rel_last_read_at $title $full_name"
    done < <(echo $response | jq -r '.[].unread') \
         3< <(echo $response | jq -r '.[].updated_at') \
         4< <(echo $response | jq -r '.[].last_read_at') \
         5< <(echo $response | jq -r '.[].subject.title') \
         6< <(echo $response | jq -r '.[].reason') \
         7< <(echo $response | jq -r '.[].repository.full_name') \
         8< <(echo $response | jq -r '.[].id') \
         9< <(echo $response |  jq -r '.[].subject.url | capture("(?<a>.*)/(?<b>.*)") | .b')

    if [ "`echo "$response" | jq '. | length'`" == "0" ]; then
        break;
    fi
    page=$((page + 1))
done

