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

    if (( delta_s <  SEC_PER_MINUTE * 2))
    then
        echo $((delta_s))" seconds ago"
        return
    elif (( delta_s <  SEC_PER_HOUR * 2))
    then
        echo $((delta_s / SEC_PER_MINUTE))" minutes ago"
        return
    elif (( delta_s <  SEC_PER_DAY * 2))
    then
        echo $((delta_s / SEC_PER_HOUR))" hours ago"
        return
    elif (( delta_s <  SEC_PER_MONTH * 2))
    then
        echo $((delta_s / SEC_PER_DAY))" days ago"
        return
    elif (( delta_s <  SEC_PER_YEAR * 2))
    then
        echo $((delta_s / SEC_PER_MONTH))" months ago"
        return
    else
        echo $((delta_s / SEC_PER_YEAR))" years ago"
        return
    fi
}

basedir=`dirname $0`
. $basedir/gh_config.sh

query=$1

page=1

total_repository_max_length=0
total_number_max_length=0
total_title_max_length=0
total_user_max_length=0

while :; do
    response=`gh api --hostname $FZFLET_GITHUB_HOSTNAME "/search/issues?q=$query&page=$page"`
    if [ "`echo $response | jq '.items | length'`" == "0" ]; then
        break;
    fi

    repository_max_length=0
    number_max_length=`echo "$response" | jq '[.items[].number | tostring | length] | max'`
    title_max_length=`echo "$response" | jq '[.items[].title | length] | max'`
    user_max_length=`echo "$response" | jq '[.items[].user.login | length] | max'`
    while read repository_url; do
        repository=`echo "$repository_url" | sed -r 's#.*/([^/]+/[^/]+)$#\1#'`

        if [ $repository_max_length -lt ${#repository} ]; then
            repository_max_length=${#repository}
        fi
    done < <(echo $response | jq -r '.items[].repository_url')

    if [ $total_repository_max_length -lt $repository_max_length ]; then
        total_repository_max_length=$((repository_max_length + FZFLET_GITHUB_REPOSITORY_LENGTH_BUFFER))
    fi
    if [ $total_number_max_length -lt $number_max_length ]; then
        total_number_max_length=$((number_max_length + FZFLET_GITHUB_NUMBER_LENGTH_BUFFER))
    fi
    if [ $total_title_max_length -lt $title_max_length ]; then
        total_title_max_length=$((title_max_length + FZFLET_GITHUB_TITLE_LENGTH_BUFFER))
    fi
    if [ $total_user_max_length -lt $user_max_length ]; then
        total_user_max_length=$((user_max_length + FZFLET_GITHUB_USER_LENGTH_BUFFER))
    fi

    while read title && read repository_url <&3 && read number <&4 && read user <&5 && read updated_at <&6 ; do
        repository=`echo "$repository_url" | sed -r 's#.*/([^/]+/[^/]+)$#\1#'`
        rel_updated_at=`rel_fmt_low_precision $updated_at`
        printf "%-${total_repository_max_length}s %-$((total_number_max_length+1))s %-${total_title_max_length}s by %-${total_user_max_length}s %s\n" "$repository" "#$number" "$title" "$user" "$rel_updated_at"
    done < <(echo $response | jq -r '.items[].title') \
         3< <(echo $response | jq -r '.items[].repository_url') \
         4< <(echo $response | jq -r '.items[].number') \
         5< <(echo $response | jq -r '.items[].user.login') \
         6< <(echo $response | jq -r '.items[].updated_at')

    page=$((page + 1))
done

