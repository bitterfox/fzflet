#!/bin/bash

basedir=`dirname $0`
. $basedir/gh_config.sh

id=$1

response=`gh api --hostname $FZFLET_GITHUB_HOSTNAME notifications/threads/$id`

url=`echo $response | jq -r '.subject.url'`
subject_type=`echo $response | jq -r '.subject.type'`

echo $subject_type

case $subject_type in
    "PullRequest" )
        pull_response=`gh api $url`
        html_url=`echo $pull_response | jq -r '.html_url'`
        xdg-open $html_url
    ;;
    *) echo $response | jq ;;
esac
