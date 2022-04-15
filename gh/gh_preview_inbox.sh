#!/bin/bash

basedir=`dirname $0`
. $basedir/gh_config.sh

id=$1

response=`gh api --hostname $FZFLET_GITHUB_HOSTNAME /notifications/threads/$id`

subject_type=`echo $response | jq -r '.subject.type'`

echo $subject_type

case $subject_type in
    "PullRequest" )
        url=`echo $response | jq -r '.subject.url'`
        repository=`echo $url | sed -r "s#.*/repos/(.*/.*)/pulls/(.*)#\1#"`
        number=`echo $url | sed -r "s#.*/repos(.*/.*)/pulls/(.*)#\2#"`
        $basedir/gh_preview_pull.sh $repository $number
    ;;
    *) echo $response | jq ;;
esac
